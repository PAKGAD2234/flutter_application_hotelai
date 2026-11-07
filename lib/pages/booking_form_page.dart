import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/booking.dart';
import '../models/hotel.dart';
import '../models/search_params.dart';
import '../services/booking_storage.dart';
import '../utils/format.dart';
import '../widgets/common.dart';
import 'booking_success_page.dart';

class BookingFormPage extends StatefulWidget {
  final Hotel hotel;
  final Room room;
  final SearchParams params;

  const BookingFormPage({
    super.key,
    required this.hotel,
    required this.room,
    required this.params,
  });

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final nights = nightsBetween(widget.params.checkIn, widget.params.checkOut);
    final booking = Booking(
      id: await BookingStorage.nextBookingId(),
      guestName: _name.text.trim(),
      hotelName: widget.hotel.name,
      roomName: widget.room.name,
      hotelImage: widget.hotel.image,
      checkIn: widget.params.checkIn,
      checkOut: widget.params.checkOut,
      guests: widget.params.guests,
      nights: nights,
      total: widget.room.price * nights,
    );
    await BookingStorage.save(booking);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => BookingSuccessPage(booking: booking)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nights = nightsBetween(widget.params.checkIn, widget.params.checkOut);
    return Scaffold(
      appBar: const AppNavBar(active: 'hotels'),
      body: SingleChildScrollView(
        child: PageContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ข้อมูลการจอง', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.hotel.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(widget.room.name),
                        Text('${formatDate(widget.params.checkIn)} - ${formatDate(widget.params.checkOut)} ($nights คืน)'),
                        const SizedBox(height: 8),
                        Text(formatBaht(widget.room.price * nights), style: const TextStyle(fontSize: 22, color: kPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'ชื่อผู้จอง'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'กรุณากรอกชื่อผู้จอง' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'กรุณากรอกเบอร์โทรศัพท์' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'อีเมล'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'กรุณากรอกอีเมล' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('ยืนยันการจอง'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
