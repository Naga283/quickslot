import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class BookingPassView extends StatelessWidget {
  final String bookingId;
  final String venueName;
  final String sportType;
  final String address;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  BookingPassView({
    super.key,
    required this.bookingId,
    required this.venueName,
    required this.sportType,
    required this.address,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  // ── Formatters ──────────────────────────────────────────────

  String get _formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatHour(DateTime time) {
    final hour = time.hour;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$h:00 $amPm';
  }

  String get _formattedTime =>
      '${_formatHour(startTime)} – ${_formatHour(endTime)}';

  String get _shortBookingId => bookingId.length > 8
      ? bookingId.substring(0, 8).toUpperCase()
      : bookingId.toUpperCase();

  // ── Share as image ──────────────────────────────────────────

  final GlobalKey _passKey = GlobalKey();

  Future<void> _sharePass(BuildContext context) async {
    try {
      final boundary =
          _passKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/quickslot_pass_$_shortBookingId.png');
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text:
              'My QuickSlot Booking Pass – $venueName on $_formattedDate at $_formattedTime',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share pass: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final accentColor = isDark
        ? const Color(0xFF00FFCC)
        : const Color(0xFF0F766E);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final dividerColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final qrFgColor = isDark ? Colors.white : Colors.black;
    final qrBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Booking Pass',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: accentColor),
            tooltip: 'Share Pass',
            onPressed: () => _sharePass(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // ── Capturable Pass Card ──────────────────────
            RepaintBoundary(
              key: _passKey,
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ── Header strip ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF00FFCC),
                                  const Color(0xFF38BDF8),
                                ]
                              : [
                                  const Color(0xFF0F766E),
                                  const Color(0xFF0284C7),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.confirmation_num_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'QUICKSLOT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Booking Pass',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'CONFIRMED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Body ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        children: [
                          // Venue
                          _InfoRow(
                            icon: Icons.stadium_rounded,
                            label: 'VENUE',
                            value: venueName,
                            accentColor: accentColor,
                            subtitleColor: subtitleColor,
                          ),
                          const SizedBox(height: 18),

                          // Sport
                          _InfoRow(
                            icon: Icons.sports_rounded,
                            label: 'SPORT',
                            value: sportType,
                            accentColor: accentColor,
                            subtitleColor: subtitleColor,
                          ),
                          const SizedBox(height: 18),

                          // Date & Time row
                          Row(
                            children: [
                              Expanded(
                                child: _InfoRow(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'DATE',
                                  value: _formattedDate,
                                  accentColor: accentColor,
                                  subtitleColor: subtitleColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _InfoRow(
                                  icon: Icons.schedule_rounded,
                                  label: 'TIME',
                                  value: _formattedTime,
                                  accentColor: accentColor,
                                  subtitleColor: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Location
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'LOCATION',
                            value: address,
                            accentColor: accentColor,
                            subtitleColor: subtitleColor,
                          ),
                          const SizedBox(height: 18),

                          // Booking ID
                          _InfoRow(
                            icon: Icons.tag_rounded,
                            label: 'BOOKING ID',
                            value: _shortBookingId,
                            accentColor: accentColor,
                            subtitleColor: subtitleColor,
                            isMono: true,
                          ),
                        ],
                      ),
                    ),

                    // ── Perforated divider ──
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          // Left half-circle notch
                          SizedBox(
                            width: 16,
                            height: 32,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          // Dashed line
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final dashCount = (constraints.maxWidth / 10)
                                    .floor();
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(dashCount, (_) {
                                    return SizedBox(
                                      width: 5,
                                      height: 1.5,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: dividerColor,
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                          // Right half-circle notch
                          SizedBox(
                            width: 16,
                            height: 32,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── QR Code ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                      child: Column(
                        children: [
                          Text(
                            'Scan to verify',
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: qrBgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.2),
                                width: 2,
                              ),
                            ),
                            child: QrImageView(
                              data: 'quickslot://booking/$bookingId',
                              version: QrVersions.auto,
                              size: 180,
                              eyeStyle: QrEyeStyle(
                                eyeShape: QrEyeShape.circle,
                                color: qrFgColor,
                              ),
                              dataModuleStyle: QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.circle,
                                color: qrFgColor,
                              ),
                              backgroundColor: qrBgColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            bookingId,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 10,
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Share Button ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () => _sharePass(context),
                icon: const Icon(Icons.share_rounded),
                label: const Text(
                  'Share Booking Pass',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Reusable info row widget ──────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final Color subtitleColor;
  final bool isMono;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.subtitleColor,
    this.isMono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: accentColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: isMono ? 'monospace' : null,
                  letterSpacing: isMono ? 1.5 : 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
