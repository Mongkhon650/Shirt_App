const express = require("express");
const router = express.Router();
const db = require("../db/connection.js");

/* ================================
      ดึงข้อมูลผู้ใช้ (เฉพาะผู้ใช้ทั่วไป)
   ================================ */
router.get("/users", async (req, res) => {
  try {
    // ดึงข้อมูลผู้ใช้ที่ไม่ใช่แอดมิน (is_admin = 0)
    const [users] = await db.execute("SELECT * FROM accounts WHERE is_admin = 0");
    
    res.status(200).json(users);
  } catch (error) {
    console.error("Error while fetching users:", error);
    res.status(500).json({
      success: false,
      message: "เกิดข้อผิดพลาดในการดึงข้อมูล",
    });
  }
});

module.exports = router;
