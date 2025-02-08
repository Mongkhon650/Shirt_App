const express = require("express");
const db = require("../db/connection.js"); // เชื่อมต่อฐานข้อมูล
const router = express.Router();

/* ================================
      ดึงข้อมูลแดชบอร์ด
   ================================ */
router.get("/dashboard", async (req, res) => {
  try {
    // ดึงข้อมูลสถิติต่างๆ
    const [productTypes] = await db.execute("SELECT COUNT(*) AS count FROM product_types");
    const [products] = await db.execute("SELECT COUNT(*) AS count FROM products");
    const [categories] = await db.execute("SELECT COUNT(*) AS count FROM product_categories");
    const [orders] = await db.execute("SELECT COUNT(*) AS count FROM orders");
    const [users] = await db.execute("SELECT COUNT(*) AS count FROM accounts WHERE is_admin = 0");
    const [revenue] = await db.execute("SELECT SUM(total_price) AS total FROM orders");

    // ส่งข้อมูลกลับไป
    res.json({
      productTypes: productTypes[0].count,
      products: products[0].count,
      categories: categories[0].count,
      orders: orders[0].count,
      users: users[0].count,
      revenue: revenue[0].total || 0,
    });
  } catch (error) {
    console.error("Error fetching dashboard data:", error);
    res.status(500).json({ message: "Failed to fetch dashboard data" });
  }
});

module.exports = router;
