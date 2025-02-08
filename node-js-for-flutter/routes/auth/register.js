const express = require("express");
const bcrypt = require("bcryptjs");
const db = require("../../db/connection.js");

const router = express.Router();

/* =========================
      ลงทะเบียนผู้ใช้ใหม่
   ========================= */
router.post("/register", async (req, res) => {
    const { name, email, password } = req.body;

    try {
        // ตรวจสอบว่าอีเมลนี้มีอยู่ในระบบแล้วหรือไม่
        const [existingUser] = await db.execute("SELECT * FROM accounts WHERE email = ?", [email]);

        if (existingUser.length > 0) {
            return res.status(400).json({
                success: false,
                message: "อีเมลนี้มีอยู่ในระบบแล้ว", 
            });
        }

        // แฮชรหัสผ่านก่อนบันทึก
        const hashedPassword = await bcrypt.hash(password, 10);

        // เพิ่มข้อมูลผู้ใช้ใหม่ลงในฐานข้อมูล
        const [result] = await db.execute(
            "INSERT INTO accounts (name, email, password) VALUES (?, ?, ?)",
            [name, email, hashedPassword]
        );

        // ตรวจสอบว่าการ INSERT สำเร็จหรือไม่
        if (result.insertId) {
            return res.status(201).json({
                success: true,
                message: "ลงทะเบียนสำเร็จ!",
            });
        } else {
            return res.status(500).json({
                success: false,
                message: "การลงทะเบียนล้มเหลว กรุณาลองอีกครั้ง",
            });
        }
    } catch (error) {
        console.error("Error during registration:", error);
        res.status(500).json({
            success: false,
            message: "เกิดข้อผิดพลาดในเซิร์ฟเวอร์",
        });
    }
});

module.exports = router;
