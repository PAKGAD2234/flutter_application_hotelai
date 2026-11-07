import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/hotel.dart';
import '../models/search_params.dart';
import '../utils/format.dart';
import '../widgets/common.dart';
import 'booking_form_page.dart';

/// หน้าที่ 3: Hotel Detail
class HotelDetailPage extends StatelessWidget {
  final Hotel hotel;
  final SearchParams params;

  const HotelDetailPage({super.key, required this.hotel, required this.params});

  void _book(BuildContext context, Room room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingFormPage(hotel: hotel, room: room, params: params),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = hotel.allImages;

    return Scaffold(
      appBar: const AppNavBar(active: 'hotels'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PageContainer(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                        child: const Text('หน้าแรก',
                            style: TextStyle(color: kPrimary, fontSize: 13)),
                      ),
                      const Text('  >  ', style: TextStyle(color: kTextMuted, fontSize: 13)),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text('โรงแรม',
                            style: TextStyle(color: kPrimary, fontSize: 13)),
                      ),
                      const Text('  >  ', style: TextStyle(color: kTextMuted, fontSize: 13)),
                      Flexible(
                        child: Text(hotel.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: kTextMuted, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Gallery(images: images),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, c) {
                      final info = _buildInfo();
                      final amenities = _buildAmenities();
                      if (c.maxWidth < 800) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [info, const SizedBox(height: 16), amenities],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: info),
                          const SizedBox(width: 24),
                          SizedBox(width: 320, child: amenities),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text('ประเภทห้องพัก',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  for (final room in hotel.rooms)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RoomCard(
                        hotel: hotel,
                        room: room,
                        onBook: () => _book(context, room),
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

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hotel.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        RatingBadge(rating: hotel.rating, reviewCount: hotel.reviewCount),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_outlined, size: 18, color: kTextMuted),
            const SizedBox(width: 4),
            Text(hotel.location, style: const TextStyle(color: kTextMuted)),
          ],
        ),
        const SizedBox(height: 16),
        Text(hotel.description,
            style: const TextStyle(height: 1.6, color: Color(0xFF3C3C50))),
      ],
    );
  }

  Widget _buildAmenities() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('สิ่งอำนวยความสะดวก',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              for (final a in hotel.amenities)
                SizedBox(
                  width: 130,
                  child: Row(
                    children: [
                      Icon(amenityIcon(a), color: kPrimary, size: 20),
                      const SizedBox(width: 8),
                      Flexible(child: Text(a)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// แกลเลอรีรูป: รูปใหญ่ซ้าย + รูปเล็กขวา
class _Gallery extends StatelessWidget {
  final List<String> images;
  const _Gallery({required this.images});

  @override
  Widget build(BuildContext context) {
    final thumbs = images.skip(1).take(2).toList();
    return SizedBox(
      height: 360,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: HotelImage(path: images.first, width: double.infinity, height: 360),
          ),
          if (thumbs.isNotEmpty) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < thumbs.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    Expanded(
                      child: HotelImage(
                        path: thumbs[i],
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Hotel hotel;
  final Room room;
  final VoidCallback onBook;

  const _RoomCard({required this.hotel, required this.room, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 14,
        spacing: 16,
        children: [
          HotelImage(path: hotel.image, width: 120, height: 84),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 220, maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 16,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.person_outline, size: 16, color: kTextMuted),
                      const SizedBox(width: 4),
                      Text('${room.maxGuests} คน',
                          style: const TextStyle(color: kTextMuted)),
                    ]),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.bed_outlined, size: 16, color: kTextMuted),
                      const SizedBox(width: 4),
                      Text(room.bed, style: const TextStyle(color: kTextMuted)),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  text: formatBaht(room.price),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800, color: kPrimary),
                  children: const [
                    TextSpan(
                      text: ' /คืน',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w400, color: kTextMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(onPressed: onBook, child: const Text('จองห้องพัก')),
            ],
          ),
        ],
      ),
    );
  }
}
