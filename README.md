# Shirt_App

1. การเตรียมฐานข้อมูล ก่อนการสร้าง project
- download mariaDB
  - ตั้งค่าข้อ mariaDB
    - user : root
    - password : "จากการป้อนค่ารหัสผ่านในเครื่องนั้น ๆ"  
- download HeidiSQL
  - download B_Shop.sql file
  - Open HeidiSQL
    - ใส่ user และ password ที่ได้ตั้งค่าจาก mariaDB
      ![image](https://github.com/user-attachments/assets/f0733e3a-efb4-463e-b272-1c27e523ad2a)
    - File>Load SQL file...> เลือก B_Shop.sql
    ![image](https://github.com/user-attachments/assets/11b91b7d-bd6e-4243-8c93-0ab1207e3200)
    - กด F9 หรือ กดที่ปุ่มนี้ ![image](https://github.com/user-attachments/assets/b6963c63-96fe-4461-afa6-15c1fd3b7ed2)

      ![image](https://github.com/user-attachments/assets/f44cc984-ac79-4e90-87f0-d65a7ed45c37)
2. การ import project
- download AndroidStudio
- download Dart and Flutter extension
- download Flutter Code และ Node.js Code จาก : Github link https://github.com/Mongkhon650/Shirt_App
  - Flutter Code | ชื่อโฟลเดอร์ > myfirstapp
  - Node.js Code | ชื่อโฟลเดอร์ > node-js-for-flutter
  - ใช้คำสั่งนี้ไปยัง Workspace ที่ต้องการ
    - git clone https://github.com/Mongkhon650/Shirt_App
3. การตั้งค่าฐานข้อมูล
- ไปที่โฟลเดอร์ของ node-js-for-flutter > db > connection.js
  - ทำการเปลี่ยน host, user กับ password เพื่อทำให้เชื่อมต่อกับเซิร์ฟเวอร์ได้ถูกต้อง
    ![image](https://github.com/user-attachments/assets/3e6efd0a-309b-49e8-9a22-f1f71e9a8caf)
- ไปที่โฟลเดอร์ของ myfirstapp > lib > utils > config.dart
- *กรณีใช้ Emulator สามารถใช้ http://10.0.2.2:3000 ได้เลย

  ![image](https://github.com/user-attachments/assets/694fbb84-b032-41b6-9e8f-f7104476d3c4)

  - ที่ http://10.1.15.113:3000 สามารถเปลี่ยนเป็น IP อื่นได้ที่มือถือได้ทำการใช้ Wi-Fi เดียวกันกับตัวเปิดเซิร์ฟเวอร์
  *- (มือถือและเซิร์ฟเวอร์จะต้องใช้ Wi-Fi เดียวกัน มือถือไม่สามารถแชร์ฮอตสปอตให้เซิร์ฟเวอรใช้ได้)
4. คำสั่ง build project
- flutter :
  - ไปยัง Android Studio
    - เปิดไฟล์ myfirstapp | ด้านในมีข้อมูลดังนี้
    ![image](https://github.com/user-attachments/assets/f030c9b4-71de-40d5-8174-82fdaf16e149)
    - ไปที่ Terminal ![image](https://github.com/user-attachments/assets/04cd413a-55dc-4061-b1f8-30407055e330)
      - พิมพ์คำสั่ง flutter pub get ใน Terminal| เพื่อทำการติดตั้ง dependencies ในแอปพลิเคชัน
      - พิมพ์คำสั่ง flutter run lib/main.dart ใน Terminal | เพื่อทำการรันแอปพลิเคชัน
- node.js :
  - ไปยัง Visual Studio Code
  - File > Open Folder... > เปิดโฟลเดอร์ node-js-for-flutter
  - Terminal > New Terminal | จากนั้นพิมพ์ใน Terminal ที่ขึ้นมาใหม่
  - พิมพ์คำสั่ง npm install เพื่อทำการติดตั้ง node_modules ของเซิร์ฟเวอร์
    
    ![image](https://github.com/user-attachments/assets/f2424b65-0115-4b6a-bdb4-82350ebb439e)

  - พิมพ์คำสั่ง npm start เพื่อทำการเปิดเซิร์ฟเวอร์
    ![image](https://github.com/user-attachments/assets/5bbf63b5-d5f3-4dfd-a9b7-dc057dbeb575)
5. การรัน emulator หรือโทรศัพท์ android
- Android Studio : Device manager > Add a new device > Create virtual device > Phone > Medium Phone > VanillaiceCream [API35 | x86_64]
  ![image](https://github.com/user-attachments/assets/a1e6744c-5fdd-46ac-9cd3-659be3559423)
  ![image](https://github.com/user-attachments/assets/387036a3-84cd-4826-b8f7-14c28a106ce8)
  ![image](https://github.com/user-attachments/assets/31563a7d-847a-4e57-811a-4b403a3739d1)
  ![image](https://github.com/user-attachments/assets/f5cb3b99-71e0-4a50-9b15-8a1c070be801)
  - ไปที่ Running Devices

  ![image](https://github.com/user-attachments/assets/b2bdd0c7-5a4d-4390-972c-7934b1c8600b)

