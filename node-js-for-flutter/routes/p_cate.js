const express = require("express");
const db = require("../db/connection.js");

const router = express.Router();

/* ================================
      เพิ่มหมวดหมู่สินค้า
   ================================ */
router.post("/add-category", async (req, res) => {
  const { name, createdBy } = req.body;

  try {
    console.log("Request Body:", req.body); // Debug ข้อมูลที่รับจาก Request

    if (!name || name.trim() === "") {
      return res.status(400).json({ success: false, message: "กรุณากรอกชื่อหมวดหมู่" });
    }

    // เพิ่มหมวดหมู่ลงฐานข้อมูล
    const [result] = await db.execute(
      "INSERT INTO product_categories (name, created_by) VALUES (?, ?)",
      [name, createdBy]
    );

    console.log("Insert Result:", result); // Debug ผลลัพธ์จากฐานข้อมูล

    res.status(201).json({
      success: true,
      message: "เพิ่มหมวดหมู่เรียบร้อยแล้ว",
      categoryId: result.insertId,
    });
  } catch (error) {
    console.error("Error while adding category:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการเพิ่มหมวดหมู่" });
  }
});

/* ================================
      ดึงข้อมูลหมวดหมู่
   ================================ */
router.get("/get-categories", async (req, res) => {
  try {
    const [rows] = await db.execute("SELECT * FROM product_categories");
    res.status(200).json(rows);
  } catch (error) {
    console.error("Error while fetching categories:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

/* ================================
      ลบหมวดหมู่สินค้า
   ================================ */
router.delete("/delete-category/:id", async (req, res) => {
  const { id } = req.params;

  try {
    await db.execute("DELETE FROM product_categories WHERE category_id = ?", [id]);
    res.status(200).json({ success: true, message: "ลบหมวดหมู่เรียบร้อยแล้ว" });
  } catch (error) {
    console.error("Error while deleting category:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการลบข้อมูล" });
  }
});

/* ================================
      แก้ไขข้อมูลหมวดหมู่
   ================================ */
router.post("/update-category/:id", async (req, res) => {
  const { id } = req.params;
  const { name, updatedBy } = req.body;

  console.log("Request Body (Server):", req.body); // Debug เพื่อตรวจสอบค่า

  try {
    if (!name || !updatedBy) {
      return res.status(400).json({ success: false, message: "กรุณากรอกข้อมูลให้ครบถ้วน" });
    }

    // อัปเดตชื่อหมวดหมู่
    await db.execute(
      "UPDATE product_categories SET name = ?, updated_by = ? WHERE category_id = ?",
      [name, updatedBy, id]
    );

    res.status(200).json({ success: true, message: "แก้ไขหมวดหมู่เรียบร้อยแล้ว" });
  } catch (error) {
    console.error("Error while updating category:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการแก้ไขหมวดหมู่" });
  }
});

module.exports = router;
