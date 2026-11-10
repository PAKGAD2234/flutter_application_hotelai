# Hotel AI

เว็บแอป Flutter สำหรับค้นหาโรงแรมและทำรายการจองตัวอย่าง

## Build เว็บในเครื่อง

ติดตั้ง Flutter SDK ก่อน จากนั้นรันคำสั่ง:

```bash
flutter pub get
flutter build web --release
```

ไฟล์เว็บที่ build แล้วอยู่ใน `build/web`

## Deploy บน Vercel

เตรียมไฟล์ `vercel.json` และ `scripts/vercel-build.sh` ที่อยู่ในโปรเจกต์นี้ไว้ใน Git repository แล้ว:

1. Push โปรเจกต์ขึ้น GitHub หรือ Git provider ที่ Vercel รองรับ
2. ใน Vercel เลือก **Add New → Project** แล้ว Import repository นี้
3. ตั้ง **Framework Preset** เป็น **Other** และ **Root Directory** เป็นโฟลเดอร์รากของโปรเจกต์
4. ให้ Vercel ใช้การตั้งค่าจาก `vercel.json` แล้วกด **Deploy**

สคริปต์จะติดตั้ง Flutter stable ในสภาพแวดล้อม build ของ Vercel และสร้างเว็บไปที่ `build/web` แอปใช้การเปลี่ยนหน้าภายใน Flutter จึงไม่ต้อง rewrite คำขอไฟล์รูปไปยังหน้า HTML

ข้อมูลการจองของตัวอย่างนี้เก็บใน Local Storage ของเบราว์เซอร์ ไม่ได้ส่งไปยังฐานข้อมูลส่วนกลาง
