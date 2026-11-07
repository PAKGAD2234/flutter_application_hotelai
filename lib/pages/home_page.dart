import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/search_params.dart';
import '../utils/format.dart';
import '../widgets/common.dart';
import 'hotel_list_page.dart';

/// หน้าที่ 1: Homepage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _destCtrl = TextEditingController(text: 'กรุงเทพฯ');
  late DateTime _checkIn;
  late DateTime _checkOut;
  int _guests = 2;
  String? _error;

  @override
  void initState() {
    super.initState();
    final d = SearchParams.defaults();
    _checkIn = d.checkIn;
    _checkOut = d.checkOut;
  }

  @override
  void dispose() {
    _destCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final first = isCheckIn ? today : _checkIn.add(const Duration(days: 1));
    final initial = isCheckIn ? _checkIn : _checkOut;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: today.add(const Duration(days: 730)),
    );
    if (picked == null) return;

    setState(() {
      _error = null;
      if (isCheckIn) {
        _checkIn = picked;
        // กฎ: Check-out ต้องหลัง Check-in อย่างน้อย 1 วัน
        if (!_checkOut.isAfter(_checkIn)) {
          _checkOut = _checkIn.add(const Duration(days: 1));
        }
      } else {
        _checkOut = picked;
      }
    });
  }

  void _search() {
    if (nightsBetween(_checkIn, _checkOut) < 1) {
      setState(() => _error = 'วันที่ Check-out ต้องหลังวันที่ Check-in อย่างน้อย 1 วัน');
      return;
    }
    final params = SearchParams(
      destination: _destCtrl.text.trim(),
      checkIn: _checkIn,
      checkOut: _checkOut,
      guests: _guests,
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HotelListPage(params: params)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavBar(active: 'home'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(),
            _buildFeatures(),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      constraints: const BoxConstraints(minHeight: 540),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/hotel_1.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: kPrimary),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xE61B1240), Color(0x401B1240)],
                ),
              ),
            ),
          ),
          PageContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EasyStay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'จองโรงแรมง่าย ๆ\nในไม่กี่ขั้นตอน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ค้นหาที่พักที่ใช่ ราคาโปร่งใส สำหรับทุกการเดินทาง',
                    style: TextStyle(color: Color(0xE6FFFFFF), fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  _buildSearchCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    final destination = _SearchField(
      label: 'เมือง / จังหวัด',
      icon: Icons.location_on_outlined,
      child: TextField(
        controller: _destCtrl,
        decoration: const InputDecoration.collapsed(hintText: 'ค้นหาจุดหมายปลายทาง'),
        style: const TextStyle(fontWeight: FontWeight.w600),
        onSubmitted: (_) => _search(),
      ),
    );
    final checkIn = _SearchField(
      label: 'เช็คอิน',
      icon: Icons.calendar_today_outlined,
      onTap: () => _pickDate(isCheckIn: true),
      child: Text(formatDate(_checkIn),
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
    final checkOut = _SearchField(
      label: 'เช็คเอาท์',
      icon: Icons.calendar_today_outlined,
      onTap: () => _pickDate(isCheckIn: false),
      child: Text(formatDate(_checkOut),
          style: const TextStyle(fontWeight: FontWeight.w600)),
    );
    final guests = _SearchField(
      label: 'ผู้เข้าพัก',
      icon: Icons.person_outline,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _guests,
          isDense: true,
          isExpanded: true,
          items: [
            for (int i = 1; i <= 8; i++)
              DropdownMenuItem(value: i, child: Text('$i คน')),
          ],
          onChanged: (v) => setState(() => _guests = v ?? _guests),
        ),
      ),
    );
    final button = SizedBox(
      height: 56,
      child: FilledButton.icon(
        onPressed: _search,
        icon: const Icon(Icons.search),
        label: const Text('ค้นหา'),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth >= 860) {
                return Row(
                  children: [
                    Expanded(flex: 3, child: destination),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: checkIn),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: checkOut),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: guests),
                    const SizedBox(width: 12),
                    button,
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  destination,
                  const SizedBox(height: 12),
                  checkIn,
                  const SizedBox(height: 12),
                  checkOut,
                  const SizedBox(height: 12),
                  guests,
                  const SizedBox(height: 12),
                  button,
                ],
              );
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    const items = [
      (Icons.bolt_rounded, 'จองง่าย', 'ไม่กี่ขั้นตอน'),
      (Icons.sell_outlined, 'ราคาคุ้มค่า', 'คัดสรรที่พักที่ดีที่สุด'),
      (Icons.shield_outlined, 'มั่นใจได้', 'ข้อมูลปลอดภัย'),
    ];
    return PageContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 48,
        runSpacing: 24,
        children: [
          for (final it in items)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: kPrimary,
                  child: Icon(it.$1, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(it.$2,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(it.$3, style: const TextStyle(color: kTextMuted)),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// ช่องกรอกในแถบค้นหา (label เล็กด้านบน + ค่า)
class _SearchField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final VoidCallback? onTap;

  const _SearchField({
    required this.label,
    required this.icon,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: kPrimary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(color: kTextMuted, fontSize: 11)),
                  const SizedBox(height: 2),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
