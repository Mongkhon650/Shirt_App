const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const db = require("../../db/connection.js");

const router = express.Router();
const SECRET_KEY = "your_secret_key";

/* =========================
      ระบบเข้าสู่ระบบ
   ========================= */

router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    // ตรวจสอบว่ามีบัญชีนี้อยู่ในระบบหรือไม่
    const [rows] = await db.execute("SELECT * FROM accounts WHERE email = ?", [email]);
    if (rows.length === 0) {
      return res.status(401).json({ success: false, message: "อีเมลหรือรหัสผ่านไม่ถูกต้อง" });
    }

    const account = rows[0];

    // ตรวจสอบรหัสผ่าน
    const isPasswordValid = await bcrypt.compare(password, account.password);
    if (!isPasswordValid) {
      return res.status(401).json({ success: false, message: "อีเมลหรือรหัสผ่านไม่ถูกต้อง" });
    }

    // สร้าง JSON Web Token (JWT)
    const token = jwt.sign({ accountId: account.account_id }, SECRET_KEY, { expiresIn: "1h" });

    res.status(200).json({
      success: true,
      token,
      name: account.name,
      isAdmin: account.is_admin === 1,
      user_id: account.account_id,
      message: "เข้าสู่ระบบสำเร็จ",
    });
  } catch (err) {
    console.error("Error during login:", err);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในเซิร์ฟเวอร์" });
  }
});

module.exports = router;
