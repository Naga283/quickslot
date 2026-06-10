import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/venues/presentation/providers/venues_providers.dart';
import '../../features/bookings/presentation/providers/bookings_providers.dart';

part 'socket_service.g.dart';

class WaitlistPromotion {
  final String slotId;
  final String message;
  WaitlistPromotion({required this.slotId, required this.message});
}

@riverpod
class SocketService extends _$SocketService {
  io.Socket? _socket;

  @override
  WaitlistPromotion? build() {
    final defaultHost = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';

    final baseUrl = const String.fromEnvironment('SOCKET_BASE_URL', defaultValue: '').isEmpty
        ? 'http://$defaultHost:4000'
        : const String.fromEnvironment('SOCKET_BASE_URL');
    
    log('[Socket] Initializing client pointing to $baseUrl');
    _socket = io.io(baseUrl, io.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());

    _socket!.onConnect((_) {
      log('[Socket] Connected successfully');
    });

    _socket!.onDisconnect((_) {
      log('[Socket] Disconnected');
    });

    // Listen to slot_updated events
    _socket!.on('slot_updated', (data) {
      log('[Socket] slot_updated event: $data');
      ref.invalidate(fetchVenueSlotsProvider);
    });

    // Listen to booking_cancelled events
    _socket!.on('booking_cancelled', (data) {
      log('[Socket] booking_cancelled event: $data');
      ref.invalidate(fetchVenueSlotsProvider);
    });

    // Listen to waitlist_promoted events
    _socket!.on('waitlist_promoted', (data) {
      log('[Socket] waitlist_promoted event: $data');
      final currentUserId = ref.read(currentUserProvider)?.id;
      final promotedUserId = data['userId'] as String?;
      
      if (currentUserId != null && currentUserId == promotedUserId) {
        log('[Socket] Current user promoted! Triggering refetch.');
        // Refresh active bookings list
        ref.read(myBookingsProvider.notifier).fetchBookings(currentUserId);
        ref.invalidate(fetchVenueSlotsProvider);
        
        // Populate state to trigger UI notification SnackBar
        state = WaitlistPromotion(
          slotId: data['slotId'] as String,
          message: 'You have been promoted from the waitlist! Your slot has been booked.',
        );
      }
    });

    _socket!.connect();

    ref.onDispose(() {
      _socket?.disconnect();
      _socket?.dispose();
    });

    return null;
  }

  void clearNotification() {
    state = null;
  }
}
