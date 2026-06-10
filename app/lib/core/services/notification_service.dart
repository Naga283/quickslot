import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_init;
import 'package:flutter_timezone/flutter_timezone.dart';

part 'notification_service.g.dart';

@riverpod
class NotificationService extends _$NotificationService {
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  @override
  void build() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> init() async {
    tz_init.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = tzInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      log('[Notification] Set local timezone to $timeZoneName');
    } catch (e) {
      log('[Notification] Failed to set local location, defaulting to UTC: $e');
    }
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        log('[Notification] User tapped on notification: ${details.payload}');
      },
    );

    // Request Android 13+ permission specifically
    final androidPlugin = _localNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
    log('[Notification] Local notifications initialized successfully');
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'quickslot_instant',
      'QuickSlot Status Updates',
      channelDescription: 'Instant booking and waitlist promotion updates',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'quickslot_reminders',
      'QuickSlot Booking Reminders',
      channelDescription: 'Reminder alerts scheduled before slot bookings',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    log('[Notification] Scheduling notification $id at $tzDateTime');

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    log('[Notification] Cancelling scheduled notification $id');
    await _localNotificationsPlugin.cancel(id);
  }
}
