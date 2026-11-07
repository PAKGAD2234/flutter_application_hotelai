import 'package:intl/intl.dart';

const List<String> _thaiMonths = [
  'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
  'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
];

/// เช่น 1 ส.ค. 2569
String formatDate(DateTime d) => '${d.day} ${_thaiMonths[d.month - 1]} ${d.year + 543}';

/// เช่น ฿1,800
String formatBaht(num value) => '฿${NumberFormat('#,##0').format(value)}';

/// จำนวนคืนระหว่างวันที่เข้าพักและวันที่ออก
int nightsBetween(DateTime checkIn, DateTime checkOut) {
  final a = DateTime(checkIn.year, checkIn.month, checkIn.day);
  final b = DateTime(checkOut.year, checkOut.month, checkOut.day);
  return b.difference(a).inDays;
}
