const express = require("express");
const db = require("../db/connection");
const router = express.Router();
const os = require("os");

// =========================
//  กำหนด Server URL สำหรับดึงรูปสินค้า
// =========================
const networkInterfaces = os.networkInterfaces();
const addresses = Object.values(networkInterfaces)
  .flat()
  .filter((iface) => iface.family === "IPv4" && !iface.internal)
  .map((iface) => iface.address);

const serverIp = addresses.length > 0 ? `http://${addresses[0]}:3000/uploads/` : "http://localhost:3000/uploads/";

/* =========================
      เพิ่มสินค้าใน Wishlist
   ========================= */
router.post("/add-to-wishlist", async (req, res) => {
  const { user_id, product_id } = req.body;

  if (!user_id || !product_id) {
    return res.status(400).json({ success: false, message: "กรุณาระบุ user_id และ product_id" });
  }

  try {
    const [existingItem] = await db.execute(
      "SELECT * FROM wishlist WHERE user_id = ? AND product_id = ?",
      [user_id, product_id]
    );

    if (existingItem.length > 0) {
      return res.status(400).json({ success: false, message: "สินค้านี้อยู่ใน Wishlist แล้ว" });
    }

    await db.execute("INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)", [user_id, product_id]);

    res.status(201).json({ success: true, message: "เพิ่มสินค้าใน Wishlist สำเร็จ" });
  } catch (error) {
    console.error("Error adding to wishlist:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการเพิ่มสินค้าใน Wishlist" });
  }
});

/* =========================
      ลบสินค้าออกจาก Wishlist
   ========================= */
router.post("/remove-from-wishlist", async (req, res) => {
  const { user_id, product_id } = req.body;

  if (!user_id || !product_id) {
    return res.status(400).json({ success: false, message: "กรุณาระบุ user_id และ product_id" });
  }

  try {
    await db.execute("DELETE FROM wishlist WHERE user_id = ? AND product_id = ?", [user_id, product_id]);

    res.status(200).json({ success: true, message: "ลบสินค้าออกจาก Wishlist สำเร็จ" });
  } catch (error) {
    console.error("Error removing from wishlist:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการลบสินค้าออกจาก Wishlist" });
  }
});

/* =========================
      ดึงข้อมูลสินค้าใน Wishlist
   ========================= */
router.get("/get-wishlist", async (req, res) => {
  const { user_id } = req.query;

  if (!user_id) {
    return res.status(400).json({ success: false, message: "กรุณาระบุ user_id" });
  }

  try {
    const [wishlistItems] = await db.execute(
      `SELECT w.wishlist_id, w.user_id, w.product_id, p.name, p.image, p.price 
       FROM wishlist w 
       JOIN products p ON w.product_id = p.product_id 
       WHERE w.user_id = ?`,
      [user_id]
    );

    // เพิ่ม URL ของรูปภาพให้กับสินค้า
    const wishlist = wishlistItems.map((item) => ({
      ...item,
      image: item.image ? `${serverIp}${item.image}` : "https://via.placeholder.com/150",
    }));

    res.status(200).json({ success: true, wishlist });
  } catch (error) {
    console.error("Error fetching wishlist:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการดึงข้อมูล Wishlist" });
  }
});

/* =========================
      ตรวจสอบว่าสินค้าอยู่ใน Wishlist หรือไม่
   ========================= */
router.get("/check-wishlist", async (req, res) => {
  const { user_id, product_id } = req.query;

  if (!user_id || !product_id) {
    return res.status(400).json({ success: false, message: "กรุณาระบุ user_id และ product_id" });
  }

  try {
    const [rows] = await db.execute(
      "SELECT * FROM wishlist WHERE user_id = ? AND product_id = ?",
      [user_id, product_id]
    );

    res.status(200).json({ success: true, isFavorite: rows.length > 0 });
  } catch (error) {
    console.error("Error checking wishlist:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการตรวจสอบ Wishlist" });
  }
});

module.exports = router;
