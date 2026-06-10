import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:quickslot_app/features/bookings/data/repositories/bookings_repository_impl.dart';
import 'package:quickslot_app/features/bookings/domain/repositories/bookings_repository.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final FutureOr<ResponseBody> Function(RequestOptions options) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }
}

void main() {
  late Dio dio;
  late Box box;

  const userId = '11111111-1111-4111-8111-111111111111';
  const slotId = '22222222-2222-4222-8222-222222222222';

  final bookingJson = {
    'id': '33333333-3333-4333-8333-333333333333',
    'userId': userId,
    'slotId': slotId,
    'createdAt': '2026-06-11T08:00:00.000Z',
  };

  setUp(() async {
    Hive.init('${Directory.systemTemp.path}/quickslot_booking_repo_test');
    box = await Hive.openBox('bookings_cache');
    await box.clear();
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:4000/api'));
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  test('createBooking posts ids and parses booking response', () async {
    RequestOptions? capturedOptions;
    dio.httpClientAdapter = _FakeAdapter((options) {
      capturedOptions = options;
      return ResponseBody.fromString(
        json.encode({'data': bookingJson}),
        201,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    final repository = BookingsRepositoryImpl(dio);
    final booking = await repository.createBooking(
      userId: userId,
      slotId: slotId,
    );

    expect(capturedOptions?.path, '/bookings');
    expect(capturedOptions?.method, 'POST');
    expect(capturedOptions?.data, {'userId': userId, 'slotId': slotId});
    expect(booking.id, bookingJson['id']);
    expect(await box.get('bookings_user_$userId'), isNull);
  });

  test('createBooking maps 409 response to BookingConflictException', () async {
    dio.httpClientAdapter = _FakeAdapter((options) {
      return ResponseBody.fromString(
        json.encode({'message': 'Slot is already booked'}),
        409,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    final repository = BookingsRepositoryImpl(dio);

    expect(
      repository.createBooking(userId: userId, slotId: slotId),
      throwsA(isA<BookingConflictException>()),
    );
  });

  test(
    'getUserBookings falls back to cached bookings when the network fails',
    () async {
      await box.put('bookings_user_$userId', json.encode([bookingJson]));
      dio.httpClientAdapter = _FakeAdapter((options) {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'offline',
        );
      });

      final repository = BookingsRepositoryImpl(dio);
      final bookings = await repository.getUserBookings(userId);

      expect(bookings, hasLength(1));
      expect(bookings.single.id, bookingJson['id']);
    },
  );
}
