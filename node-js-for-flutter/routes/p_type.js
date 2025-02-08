const express = require("express");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const db = require("../db/connection.js");
const os = require("os");

const router = express.Router();

// =============================
// กำหนดค่าเซิร์ฟเวอร์สำหรับรูปภาพ
// =============================
const networkInterfaces = os.networkInterfaces();
const addresses = Object.values(networkInterfaces)
  .flat()
  .filter((iface) => iface.family === "IPv4" && !iface.internal)
  .map((iface) => iface.address);

const serverIp = addresses.length > 0 ? addresses[0] : "localhost";
const baseUrl = `http://${serverIp}:3000/uploads/`;

// =============================
// ตั้งค่าการอัปโหลดไฟล์
// =============================
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + "-" + uniqueSuffix + path.extname(file.originalname));
  },
});

const upload = multer({
  storage: storage,
  fileFilter: (req, file, cb) => {
    console.log("Uploaded file mimetype:", file.mimetype);
    const allowedTypes = ["image/jpeg", "image/png", "image/gif", "application/octet-stream"];

    if (!allowedTypes.includes(file.mimetype)) {
      return cb(new Error("ไฟล์ที่อัปโหลดต้องเป็นรูปภาพเท่านั้น"));
    }

    if (file.mimetype === "application/octet-stream") {
      file.mimetype = "image/jpeg";
    }

    cb(null, true);
  },
});

// =============================
// เพิ่มประเภทสินค้า
// =============================
router.post("/add-product-type", upload.single("image"), async (req, res) => {
  try {
    const { name, createdBy } = req.body;
    const imagePath = req.file ? req.file.filename : null;

    if (!name || !imagePath) {
      return res.status(400).json({ success: false, message: "กรุณากรอกข้อมูลให้ครบถ้วน" });
    }

    const [result] = await db.execute(
      "INSERT INTO product_types (name, image, created_by) VALUES (?, ?, ?)",
      [name, imagePath, createdBy]
    );

    res.status(201).json({ success: true, message: "เพิ่มประเภทสินค้าเรียบร้อยแล้ว", productTypeId: result.insertId });
  } catch (error) {
    console.error("Error while adding product type:", error);
    if (req.file) fs.unlinkSync(`uploads/${req.file.filename}`);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการเพิ่มประเภทสินค้า" });
  }
});

// =============================
// ดึงข้อมูลประเภทสินค้า
// =============================
router.get("/get-product-types", async (req, res) => {
  try {
    const [rows] = await db.execute("SELECT * FROM product_types");

    const productTypes = rows.map((row) => ({
      ...row,
      image: row.image ? baseUrl + row.image : null,
    }));

    res.status(200).json(productTypes);
  } catch (error) {
    console.error("Error while fetching product types:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

// =============================
// ลบประเภทสินค้า
// =============================
router.delete("/delete-product-type/:id", async (req, res) => {
  const { id } = req.params;
  try {
    // ดึงข้อมูลประเภทสินค้าที่จะลบเพื่อลบไฟล์รูปภาพ
    const [rows] = await db.execute("SELECT image FROM product_types WHERE product_type_id = ?", [id]);

    if (rows.length > 0) {
      const imagePath = rows[0].image;
      if (imagePath) {
        const fullPath = path.join(__dirname, "../uploads", imagePath);
        if (fs.existsSync(fullPath)) fs.unlinkSync(fullPath);
      }
    }

    // ลบข้อมูลประเภทสินค้าจากฐานข้อมูล
    await db.execute("DELETE FROM product_types WHERE product_type_id = ?", [id]);

    res.status(200).json({ success: true, message: "ลบประเภทสินค้าเรียบร้อยแล้ว" });
  } catch (error) {
    console.error("Error while deleting product type:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการลบข้อมูล" });
  }
});

// =============================
// แก้ไขประเภทสินค้า
// =============================
router.post("/update-product-type/:id", upload.single("image"), async (req, res) => {
  const { id } = req.params;
  const { name } = req.body;
  const imagePath = req.file ? req.file.filename : null;

  try {
    if (!name) {
      return res.status(400).json({ success: false, message: "กรุณากรอกชื่อประเภท" });
    }

    if (imagePath) {
      const [rows] = await db.execute("SELECT image FROM product_types WHERE product_type_id = ?", [id]);
      if (rows.length > 0) {
        const oldImage = rows[0].image;
        if (oldImage) fs.unlinkSync(`uploads/${oldImage}`);
      }
      await db.execute("UPDATE product_types SET name = ?, image = ? WHERE product_type_id = ?", [name, imagePath, id]);
    } else {
      await db.execute("UPDATE product_types SET name = ? WHERE product_type_id = ?", [name, id]);
    }

    res.status(200).json({ success: true, message: "แก้ไขประเภทสินค้าเรียบร้อยแล้ว" });
  } catch (error) {
    console.error("Error while updating product type:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการแก้ไขประเภทสินค้า" });
  }
});

module.exports = router;
