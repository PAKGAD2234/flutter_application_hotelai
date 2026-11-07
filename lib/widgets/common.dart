import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/search_params.dart';
import '../pages/hotel_list_page.dart';

/// จัดเนื้อหาให้อยู่กึ่งกลางและจำกัดความกว้าง (Desktop)
class PageContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PageContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// แถบเมนูด้านบน: โลโก้ + หน้าแรก / โรงแรม / เกี่ยวกับเรา + ปุ่มจองห้องพัก
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  /// 'home' | 'hotels' | ''
  final String active;

  const AppNavBar({super.key, this.active = ''});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  void _goHome(BuildContext context) =>
      Navigator.of(context).popUntil((r) => r.isFirst);

  void _goHotels(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HotelListPage(params: SearchParams.defaults()),
      ),
      (r) => r.isFirst,
    );
  }

  void _about(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('เกี่ยวกับเรา'),
        content: const Text(
          'EasyStay เป็นเว็บไซต์ต้นแบบสำหรับจองโรงแรม สร้างขึ้นเพื่อ Mini Project '
          'รายวิชา DevOps และการผสมผสานระบบ ข้อมูลทั้งหมดเป็นข้อมูลตัวอย่างเพื่อการสาธิตเท่านั้น',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 1000;
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kBorder)),
      ),
      child: PageContainer(
        child: Row(
          children: [
            InkWell(
              onTap: () => _goHome(context),
              child: const Row(
                children: [
                  Icon(Icons.king_bed_rounded, color: kPrimary, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'EasyStay',
                    style: TextStyle(
                      color: kPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (wide) ...[
              _NavLink('หน้าแรก', active == 'home', () => _goHome(context)),
              _NavLink('โรงแรม', active == 'hotels', () => _goHotels(context)),
              _NavLink('เกี่ยวกับเรา', false, () => _about(context)),
              const SizedBox(width: 12),
            ],
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              onPressed: () => _goHotels(context),
              child: const Text('จองห้องพัก'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink(this.label, this.active, this.onTap);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: active ? kPrimary : kTextMuted,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// รูปภาพโรงแรม (มี fallback ถ้าโหลดรูปไม่ได้)
class HotelImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BorderRadius radius;

  const HotelImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.radius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: kPrimaryLight,
          child: const Icon(Icons.hotel, color: kPrimary, size: 40),
        ),
      ),
    );
  }
}

/// คะแนนรีวิว เช่น ★ 4.8 (326 รีวิว)
class RatingBadge extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingBadge({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFF5A623), size: 20),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(width: 6),
        Text('($reviewCount รีวิว)',
            style: const TextStyle(color: kTextMuted, fontSize: 13)),
      ],
    );
  }
}

IconData amenityIcon(String name) {
  switch (name) {
    case 'Wi-Fi':
      return Icons.wifi_rounded;
    case 'สระว่ายน้ำ':
      return Icons.pool_rounded;
    case 'ฟิตเนส':
      return Icons.fitness_center_rounded;
    case 'ที่จอดรถ':
      return Icons.local_parking_rounded;
    case 'อาหารเช้า':
      return Icons.free_breakfast_rounded;
    case 'สปา':
      return Icons.spa_rounded;
    default:
      return Icons.check_circle_outline;
  }
}

/// ไอคอน + ชื่อสิ่งอำนวยความสะดวก
class AmenityTag extends StatelessWidget {
  final String name;
  const AmenityTag(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(amenityIcon(name), size: 16, color: kTextMuted),
        const SizedBox(width: 4),
        Text(name, style: const TextStyle(color: kTextMuted, fontSize: 13)),
      ],
    );
  }
}

/// การ์ดพื้นขาวขอบมน
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x0F1B1240), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: child,
    );
  }
}

/// แถวข้อมูล label ซ้าย / value ขวา
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  final double valueSize;

  const InfoRow(
    this.label,
    this.value, {
    super.key,
    this.bold = false,
    this.valueColor,
    this.valueSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: kTextMuted, fontSize: 14)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Text(
          '© EasyStay — ต้นแบบเพื่อการสาธิต ข้อมูลทั้งหมดเป็นข้อมูลตัวอย่าง',
          style: TextStyle(color: kTextMuted, fontSize: 12),
        ),
      ),
    );
  }
}
