class SearchParams {
  final String destination;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  const SearchParams({
    required this.destination,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  int get nights => checkOut.difference(checkIn).inDays;

  factory SearchParams.defaults() {
    final now = DateTime.now();
    final checkIn = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return SearchParams(
      destination: 'กรุงเทพฯ',
      checkIn: checkIn,
      checkOut: checkIn.add(const Duration(days: 1)),
      guests: 2,
    );
  }
}
