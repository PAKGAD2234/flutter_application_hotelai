import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/booking.dart';
import '../utils/format.dart';
import '../widgets/common.dart';

/// หน้าที่ 5: Booking Success
class BookingSuccessPage extends StatelessWidget {
  final Booking booking;

  const BookingSuccessPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, kPrimaryLight],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PageContainer(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 34,
                        backgroundColor: kSuccess,
                        child: Icon(Icons.check_rounded, color: Colors.white, size: 42),
                      ),
                      const SizedBox(height: 18),
                      const Text('จองห้องพักสำเร็จ!',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      const Text(
                        'ขอบคุณที่ใช้บริการ EasyStay\nรายละเอียดการจองของคุณมีดังนี้',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kTextMuted, height: 1.5),
                      ),
                      const SizedBox(height: 28),
                      AppCard(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('รายละเอียดการจอง',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 14),
                            HotelImage(
                                path: booking.hotelImage,
                                width: double.infinity,
                                height: 170),
                            const SizedBox(height: 14),
                            InfoRow('หมายเลขการจอง', booking.id, bold: true),
                            InfoRow('ชื่อผู้จอง', booking.guestName),
                            InfoRow('โรงแรม', booking.hotelName),
                            InfoRow('ห้องพัก', booking.roomName),
                            InfoRow('วันที่เข้าพัก',
                                '${formatDate(booking.checkIn)} - ${formatDate(booking.checkOut)} (${booking.nights} คืน)'),
                            InfoRow('ผู้เข้าพัก', '${booking.guests} คน'),
                            const Divider(height: 26, color: kBorder),
                            InfoRow(
                              'ราคารวม',
                              formatBaht(booking.total),
                              bold: true,
                              valueColor: kPrimary,
                              valueSize: 22,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () =>
                            Navigator.of(context).popUntil((r) => r.isFirst),
                        icon: const Icon(Icons.home_outlined),
                        label: const Text('กลับสู่หน้าหลัก'),
                      ),
                    ],
                  ),
                ),
              ),
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
