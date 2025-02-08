import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // ดึงตำแหน่ง GPS ปัจจุบัน
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ตรวจสอบว่ามีการเปิด GPS หรือไม่
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // ถ้า GPS ปิด ให้คืนค่า null
    }

    // ขอสิทธิ์ใช้งาน GPS
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // ถ้าผู้ใช้ปฏิเสธ
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null; // ถ้าผู้ใช้บล็อค GPS ให้คืนค่า null
    }

    // ดึงพิกัดปัจจุบัน
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // แปลงพิกัดเป็นที่อยู่ (Reverse Geocoding)
  static Future<Map<String, String>?> getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: "th_TH", // ใช้ภาษาไทย
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return {
          "street": place.street ?? "",         // ถนน / หมู่บ้าน
          "district": place.subLocality ?? "",  // ตำบล / แขวง
          "city": place.locality ?? "",         // อำเภอ / เขต
          "province": place.administrativeArea ?? "", // จังหวัด
          "postal_code": place.postalCode ?? "", // รหัสไปรษณีย์
        };
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return null;
  }
}
