# Shirt_App

1. การเตรียมฐานข้อมูล ก่อนการสร้าง project
- download mariaDB
  - ตั้งค่าข้อ mariaDB
    - user : root
    - password : "จากการป้อนค่ารหัสผ่านในเครื่องนั้น ๆ"  
- download HeidiSQL
  - download B_Shop.sql file
2. การ import project
- download AndroidStudio
- download Dart and Flutter extension
- download Flutter Code และ Node.js Code จาก : Github link https://github.com/Mongkhon650/Shirt_App
  - Flutter Code | ชื่อโฟลเดอร์ > myfirstapp
  - Node.js Code | ชื่อโฟลเดอร์ > node-js-for-flutter
  - ใช้คำสั่งนี้ไปยัง Workspace ที่ต้องการ
    - git clone https://github.com/Mongkhon650/Shirt_App
3. การตั้งค่าฐานข้อมูล
- Open HeidiSQL
  - ใส่ user และ password ที่ได้ตั้งค่าจาก mariaDB
    ![image](https://github.com/user-attachments/assets/f0733e3a-efb4-463e-b272-1c27e523ad2a)
  - File>Load SQL file...> เลือก B_Shop.sql
  ![image](https://github.com/user-attachments/assets/11b91b7d-bd6e-4243-8c93-0ab1207e3200)
  - กด F9 หรือ กดที่ปุ่มนี้ ![image](https://github.com/user-attachments/assets/b6963c63-96fe-4461-afa6-15c1fd3b7ed2)

    ![image](https://github.com/user-attachments/assets/f44cc984-ac79-4e90-87f0-d65a7ed45c37)
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
  - Terminal > New Terminal | จากนั้นพิมพ์ใน Terminal ที่ขึ้นมาใหม่ > npm start
    ![image](https://github.com/user-attachments/assets/5bbf63b5-d5f3-4dfd-a9b7-dc057dbeb575)
5. การรัน emulator หรือโทรศัพท์ android
- Android Studio : Device manager > Add a new device > Create virtual device > Phone > Medium Phone > VanillaiceCream [API35 | x86_64]
  ![image](https://github.com/user-attachments/assets/a1e6744c-5fdd-46ac-9cd3-659be3559423)

