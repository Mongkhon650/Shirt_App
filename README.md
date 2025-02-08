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
- download Flutter Code : Github link https://github.com/Mongkhon650/Shirt_App | ชื่อโฟลเดอร์ > myfirstapp
- download Node.js Code : Github link https://github.com/Mongkhon650/Shirt_App | ชื่อโฟลเดอร์ > node-js-for-flutter
3. การตั้งค่าฐานข้อมูล
- Open HeidiSQL
  - ใส่ user และ password ที่ได้ตั้งค่าจาก mariaDB
    ![image](https://github.com/user-attachments/assets/f0733e3a-efb4-463e-b272-1c27e523ad2a)
  - File>Load SQL file...> เลือก B_Shop.sql
  ![image](https://github.com/user-attachments/assets/11b91b7d-bd6e-4243-8c93-0ab1207e3200)
  - กด F9 หรือ กดที่ปุ่มนี้ ![image](https://github.com/user-attachments/assets/b6963c63-96fe-4461-afa6-15c1fd3b7ed2)

    ![image](https://github.com/user-attachments/assets/f44cc984-ac79-4e90-87f0-d65a7ed45c37)
4. คำสั่ง build project
- flutter : termenal > flutter run app
- node.js :termenal > npm start
  - ไปยัง Visual Studio Code
  - File > Open Folder... > เปิดโฟลเดอร์ node-js-for-flutter
  - Terminal > New Terminal | จากนั้นพิมพ์ใน Terminal ที่ขึ้นมาใหม่ > npm start
    ![image](https://github.com/user-attachments/assets/5bbf63b5-d5f3-4dfd-a9b7-dc057dbeb575)
5. การรัน emulator หรือโทรศัพท์ android
- Android Studio : device manager > create 
