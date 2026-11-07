class Room {
  final String name;
  final int maxGuests;
  final String bed;
  final int price;

  const Room({
    required this.name,
    required this.maxGuests,
    required this.bed,
    required this.price,
  });
}

class Hotel {
  final String id;
  final String name;
  final String image;
  final List<String> gallery;
  final String location;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> amenities;
  final List<Room> rooms;

  const Hotel({
    required this.id,
    required this.name,
    required this.image,
    required this.gallery,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.amenities,
    required this.rooms,
  });

  List<String> get allImages => [image, ...gallery];
  int get startPrice =>
      rooms.map((room) => room.price).reduce((a, b) => a < b ? a : b);
}
