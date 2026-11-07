class Booking {
  final String id;
  final String guestName;
  final String hotelName;
  final String roomName;
  final String hotelImage;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int nights;
  final num total;

  const Booking({
    required this.id,
    required this.guestName,
    required this.hotelName,
    required this.roomName,
    required this.hotelImage,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.nights,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'guestName': guestName,
        'hotelName': hotelName,
        'roomName': roomName,
        'hotelImage': hotelImage,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'guests': guests,
        'nights': nights,
        'total': total,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        guestName: json['guestName'] as String,
        hotelName: json['hotelName'] as String,
        roomName: json['roomName'] as String,
        hotelImage: json['hotelImage'] as String,
        checkIn: DateTime.parse(json['checkIn'] as String),
        checkOut: DateTime.parse(json['checkOut'] as String),
        guests: json['guests'] as int,
        nights: json['nights'] as int,
        total: json['total'] as num,
      );
}
