import 'package:flutter/material.dart';

import '../constants.dart';
import '../data/hotels.dart';
import '../models/hotel.dart';
import '../models/search_params.dart';
import '../utils/format.dart';
import '../widgets/common.dart';
import 'hotel_detail_page.dart';

/// หน้าที่ 2: Hotel List
class HotelListPage extends StatefulWidget {
  final SearchParams params;

  const HotelListPage({super.key, required this.params});

  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  String _sort = 'recommended';
  bool _showAll = false;

  static const _sortLabels = {
    'recommended': 'แนะนำ',
    'priceAsc': 'ราคา: ต่ำ → สูง',
    'priceDesc': 'ราคา: สูง → ต่ำ',
    'rating': 'คะแนนสูงสุด',
  };

  List<Hotel> get _results {
    final q = widget.params.destination.trim().toLowerCase();
    var list = kHotels.where((h) {
      if (_showAll || q.isEmpty) return true;
      return h.name.toLowerCase().contains(q) ||
          h.location.toLowerCase().contains(q);
    }).toList();

    switch (_sort) {
      case 'priceAsc':
        list.sort((a, b) => a.startPrice.compareTo(b.startPrice));
        break;
      case 'priceDesc':
        list.sort((a, b) => b.startPrice.compareTo(a.startPrice));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.params;
    final results = _results;
    final dest = p.destination.isEmpty ? 'ทุกจุดหมาย' : p.destination;

    return Scaffold(
      appBar: const AppNavBar(active: 'hotels'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageContainer(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ผลการค้นหา',
                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            Text(
                              '$dest • ${formatDate(p.checkIn)} - ${formatDate(p.checkOut)} '
                              '(${p.nights} คืน) • ${p.guests} คน',
                              style: const TextStyle(color: kTextMuted),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: kBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sort,
                            items: [
                              for (final e in _sortLabels.entries)
                                DropdownMenuItem(
                                  value: e.key,
                                  child: Text('เรียงตาม: ${e.value}'),
                                ),
                            ],
                            onChanged: (v) => setState(() => _sort = v ?? _sort),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (results.isEmpty)
                    AppCard(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          const Icon(Icons.search_off, size: 40, color: kTextMuted),
                          const SizedBox(height: 8),
                          Text('ไม่พบโรงแรมที่ตรงกับ "$dest"'),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => setState(() => _showAll = true),
                            child: const Text('แสดงโรงแรมทั้งหมด'),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    )
                  else
                    for (final h in results)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _HotelCard(
                          hotel: h,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HotelDetailPage(hotel: h, params: p),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onTap;

  const _HotelCard({required this.hotel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 720;

          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hotel.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              RatingBadge(rating: hotel.rating, reviewCount: hotel.reviewCount),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: kTextMuted),
                  const SizedBox(width: 4),
                  Text(hotel.location, style: const TextStyle(color: kTextMuted)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [for (final a in hotel.amenities) AmenityTag(a)],
              ),
            ],
          );

          final price = Column(
            crossAxisAlignment: compact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('เริ่มต้น', style: TextStyle(color: kTextMuted, fontSize: 12)),
              Text.rich(
                TextSpan(
                  text: formatBaht(hotel.startPrice),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800, color: kPrimary),
                  children: const [
                    TextSpan(
                      text: ' /คืน',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w400, color: kTextMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(onPressed: onTap, child: const Text('ดูรายละเอียด ')),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HotelImage(path: hotel.image, width: double.infinity, height: 200),
                const SizedBox(height: 14),
                details,
                const SizedBox(height: 14),
                price,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HotelImage(path: hotel.image, width: 300, height: 190),
              const SizedBox(width: 20),
              Expanded(child: details),
              const SizedBox(width: 16),
              price,
            ],
          );
        },
      ),
    );
  }
}
