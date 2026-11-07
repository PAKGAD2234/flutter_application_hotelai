import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/booking.dart';


/// เก็บข้อมูลการจองตัวอย่างในเบราว์เซอร์ (Local Storage) ด้วย shared_preferences
class BookingStorage {
  static const _bookingsKey = 'easystay_bookings';
  static const _counterKey = 'easystay_booking_counter';

  /// สร้างหมายเลขการจองตัวอย่าง เช่น ES-20261107-001
  static Future<String> nextBookingId() async {
    final now = DateTime.now();
    final date = '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
    int counter = 1;
    try {
      final prefs = await SharedPreferences.getInstance();
      counter = (prefs.getInt(_counterKey) ?? 0) + 1;
      await prefs.setInt(_counterKey, counter);
    } catch (_) {
      counter = now.millisecond % 999 + 1;
    }
    return 'ES-$date-${counter.toString().padLeft(3, '0')}';
  }

  static Future<void> save(Booking booking) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_bookingsKey) ?? [];
      list.add(jsonEncode(booking.toJson()));
      await prefs.setStringList(_bookingsKey, list);
    } catch (_) {
      // ถ้าบันทึกไม่ได้ก็ไม่กระทบการสาธิต
    }
  }

  static Future<List<Booking>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_bookingsKey) ?? [];
      return list
          .map((s) => Booking.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
