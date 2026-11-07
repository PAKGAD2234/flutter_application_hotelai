import '../models/hotel.dart';

/// ข้อมูลโรงแรมตัวอย่าง (Mock Data) ใช้รูปจาก assets/image/hotel_1..7.jpg
const List<Hotel> kHotels = [
  Hotel(
    id: 'riverview',
    name: 'RiverView Hotel',
    image: 'assets/image/hotel_1.jpg',
    gallery: ['assets/image/hotel_2.jpg', 'assets/image/hotel_3.jpg'],
    location: 'กรุงเทพฯ, ประเทศไทย',
    rating: 4.8,
    reviewCount: 326,
    description:
        'โรงแรมริมแม่น้ำใจกลางกรุงเทพฯ ห้องพักกว้างขวางพร้อมวิวเมือง '
        'เดินทางสะดวกใกล้รถไฟฟ้า เหมาะทั้งการท่องเที่ยวและการเดินทางเพื่อธุรกิจ '
        'พร้อมสระว่ายน้ำและฟิตเนสให้บริการตลอดวัน',
    amenities: ['Wi-Fi', 'สระว่ายน้ำ', 'ฟิตเนส', 'ที่จอดรถ'],
    rooms: [
      Room(name: 'ห้องดีลักซ์ (Deluxe Room)', maxGuests: 2, bed: '1 เตียงใหญ่', price: 1800),
      Room(name: 'ห้องแฟมิลี่ (Family Room)', maxGuests: 4, bed: '2 เตียงใหญ่', price: 3200),
    ],
  ),
  Hotel(
    id: 'citypark',
    name: 'City Park Hotel',
    image: 'assets/image/hotel_4.jpg',
    gallery: ['assets/image/hotel_5.jpg'],
    location: 'กรุงเทพฯ, ประเทศไทย',
    rating: 4.5,
    reviewCount: 110,
    description:
        'โรงแรมสไตล์โมเดิร์นใกล้สวนสาธารณะ บรรยากาศสงบ เดินทางง่าย '
        'ราคาคุ้มค่า เหมาะสำหรับนักท่องเที่ยวที่ต้องการความสะดวกสบายในราคาประหยัด',
    amenities: ['Wi-Fi', 'ที่จอดรถ', 'อาหารเช้า', 'ฟิตเนส'],
    rooms: [
      Room(name: 'ห้องสแตนดาร์ด (Standard Room)', maxGuests: 2, bed: '1 เตียงใหญ่', price: 1200),
      Room(name: 'ห้องดีลักซ์ (Deluxe Room)', maxGuests: 3, bed: '1 เตียงใหญ่ + โซฟาเบด', price: 1600),
    ],
  ),
  Hotel(
    id: 'boutique',
    name: 'EasyStay Boutique',
    image: 'assets/image/hotel_6.jpg',
    gallery: ['assets/image/hotel_7.jpg'],
    location: 'กรุงเทพฯ, ประเทศไทย',
    rating: 4.6,
    reviewCount: 143,
    description:
        'โรงแรมบูติคขนาดเล็กตกแต่งอบอุ่น มีเอกลักษณ์ ให้บริการแบบเป็นกันเอง '
        'พร้อมคาเฟ่และสปาให้ผ่อนคลายหลังจากเที่ยวมาทั้งวัน',
    amenities: ['Wi-Fi', 'สปา', 'อาหารเช้า', 'สระว่ายน้ำ'],
    rooms: [
      Room(name: 'ห้องบูติค (Boutique Room)', maxGuests: 2, bed: '1 เตียงใหญ่', price: 1500),
      Room(name: 'ห้องสวีท (Boutique Suite)', maxGuests: 3, bed: '1 เตียงใหญ่ + โซฟาเบด', price: 2400),
    ],
  ),
];
