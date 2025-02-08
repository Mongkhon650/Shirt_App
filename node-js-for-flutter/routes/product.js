const express = require("express");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const db = require("../db/connection.js");
const os = require("os");

const router = express.Router();

const networkInterfaces = os.networkInterfaces();
const addresses = Object.values(networkInterfaces)
  .flat()
  .filter((iface) => iface.family === "IPv4" && !iface.internal)
  .map((iface) => iface.address);

const serverIp = addresses.length > 0 ? addresses[0] : "localhost";
const baseUrl = `http://${serverIp}:3000/uploads/`;

// ตั้งค่าการจัดเก็บไฟล์รูปภาพ
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
      
      // กำหนดประเภทไฟล์ที่อนุญาตให้อัปโหลด
      const allowedTypes = ["image/jpeg", "image/png", "image/gif", "application/octet-stream"];
  
      if (!allowedTypes.includes(file.mimetype)) {
        return cb(new Error("ไฟล์ที่อัปโหลดต้องเป็นรูปภาพเท่านั้น"));
      }
  
      // แก้ไข mimetype หากเป็น application/octet-stream
      if (file.mimetype === "application/octet-stream") {
        const fileExtension = path.extname(file.originalname).toLowerCase(); // ตรวจสอบนามสกุลไฟล์
        if (fileExtension === ".jpg" || fileExtension === ".jpeg") {
          file.mimetype = "image/jpeg";
        } else if (fileExtension === ".png") {
          file.mimetype = "image/png";
        } else if (fileExtension === ".gif") {
          file.mimetype = "image/gif";
        } else {
          return cb(new Error("นามสกุลไฟล์ไม่ถูกต้อง หรือไม่รองรับ"));
        }
      }
  
      cb(null, true); // ผ่านการตรวจสอบ
    },
  });
  

// เพิ่มสินค้า
// เพิ่มสินค้าและโปรโมชั่นในคำขอเดียวกัน
router.post("/add-product", upload.single("image"), async (req, res) => {
    const {
      name,
      description,
      price,
      product_type_id,
      category_id,
      stock,
      createdBy,
      usePromotion, // รับค่าจาก frontend ว่าจะใช้โปรโมชันหรือไม่
      discount_rate,
      start_date,
      end_date,
    } = req.body;
    const imagePath = req.file ? req.file.filename : null;
  
    try {
      // ตรวจสอบข้อมูลสินค้า
      if (!name || !price || !product_type_id || !category_id || !stock || !createdBy) {
        return res.status(400).json({ success: false, message: "กรุณากรอกข้อมูลสินค้าให้ครบถ้วน" });
      }
  
      // เพิ่มข้อมูลสินค้า
      const [productResult] = await db.execute(
        "INSERT INTO products (name, description, price, product_type_id, category_id, stock, image, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        [name, description, price, product_type_id, category_id, stock, imagePath, createdBy]
      );
  
      const productId = productResult.insertId;
  
      // ตรวจสอบว่ามีการใช้โปรโมชันหรือไม่
      if (usePromotion === "true" && discount_rate && start_date && end_date) {
        // เพิ่มข้อมูลโปรโมชัน
        const [promotionResult] = await db.execute(
          "INSERT INTO promotions (discount_rate, start_date, end_date, created_by) VALUES (?, ?, ?, ?)",
          [discount_rate, start_date, end_date, createdBy]
        );
  
        const promotionId = promotionResult.insertId;
  
        // เชื่อมโยงสินค้าเข้ากับโปรโมชัน
        await db.execute(
          "INSERT INTO promotion_products (promotion_id, product_id) VALUES (?, ?)",
          [promotionId, productId]
        );
      }
  
      res.status(201).json({ success: true, message: "เพิ่มสินค้าสำเร็จ", productId });
    } catch (error) {
      console.error("Error while adding product:", error);
      if (req.file) fs.unlinkSync(`uploads/${req.file.filename}`);
      res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการเพิ่มสินค้า" });
    }
  });
  

// ดึงข้อมูลสินค้า
router.get("/get-products", async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT p.*, pt.name AS product_type_name, c.name AS category_name
      FROM products p
      LEFT JOIN product_types pt ON p.product_type_id = pt.product_type_id
      LEFT JOIN product_categories c ON p.category_id = c.category_id
    `);

    const products = rows.map((row) => ({
      ...row,
      image: row.image ? baseUrl + row.image : null,
    }));

    res.status(200).json(products);
  } catch (error) {
    console.error("Error while fetching products:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า" });
  }
});

// ดึงสินค้าตาม product_type_id
router.get("/get-products-by-type/:productTypeId", async (req, res) => {
  const { productTypeId } = req.params;

  try {
    // ดึงข้อมูลสินค้าตาม product_type_id
    const [rows] = await db.execute(
      `
      SELECT p.*, pt.name AS product_type_name, c.name AS category_name
      FROM products p
      LEFT JOIN product_types pt ON p.product_type_id = pt.product_type_id
      LEFT JOIN product_categories c ON p.category_id = c.category_id
      WHERE p.product_type_id = ?
      `,
      [productTypeId]
    );

    // เพิ่ม URL รูปภาพ
    const products = rows.map((row) => ({
      ...row,
      image: row.image ? baseUrl + row.image : null,
    }));

    res.status(200).json(products);
  } catch (error) {
    console.error("Error while fetching products by product type:", error);
    res.status(500).json({
      success: false,
      message: "เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า",
    });
  }
});


// ดึงสินค้าตาม category_id
router.get("/get-products/:categoryId", async (req, res) => {
  const { categoryId } = req.params;

  try {
    // ดึงข้อมูลสินค้าตาม category_id
    const [rows] = await db.execute(
      `
      SELECT p.*, pt.name AS product_type_name, c.name AS category_name
      FROM products p
      LEFT JOIN product_types pt ON p.product_type_id = pt.product_type_id
      LEFT JOIN product_categories c ON p.category_id = c.category_id
      WHERE p.category_id = ?
      `,
      [categoryId]
    );

    // เพิ่ม URL รูปภาพ
    const products = rows.map((row) => ({
      ...row,
      image: row.image ? baseUrl + row.image : null,
    }));

    res.status(200).json(products);
  } catch (error) {
    console.error("Error while fetching products by category:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า" });
  }
});

// ดึงสินต้าตาม id
router.get("/get-product/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await db.execute("SELECT * FROM products WHERE product_id = ?", [id]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: "Product not found" });
    }

    const product = rows[0];
    product.image = product.image ? baseUrl + product.image : null;

    res.status(200).json(product);
  } catch (error) {
    console.error("Error while fetching product:", error);
    res.status(500).json({ success: false, message: "Failed to fetch product details" });
  }
});



// ลบสินค้า
router.delete("/delete-product/:id", async (req, res) => {
    const { id } = req.params;
  
    try {
      // ตรวจสอบว่ามีสินค้าอยู่หรือไม่
      const [rows] = await db.execute("SELECT image FROM products WHERE product_id = ?", [id]);
      if (rows.length === 0) {
        return res.status(404).json({ success: false, message: "ไม่พบสินค้าที่ต้องการลบ" });
      }
  
      // ลบข้อมูลโปรโมชันที่เกี่ยวข้อง
      await db.execute(
        `
        DELETE p, pp
        FROM promotions p
        JOIN promotion_products pp ON p.promotion_id = pp.promotion_id
        WHERE pp.product_id = ?
        `,
        [id]
      );
  
      // ลบรูปภาพสินค้า (ถ้ามี)
      if (rows[0].image) {
        const fullPath = path.join(__dirname, "../uploads", rows[0].image);
        if (fs.existsSync(fullPath)) {
          try {
            fs.unlinkSync(fullPath);
          } catch (err) {
            console.error(`Error while deleting image: ${err}`);
          }
        }
      }
  
      // ลบสินค้าจากตาราง products
      await db.execute("DELETE FROM products WHERE product_id = ?", [id]);
  
      res.status(200).json({ success: true, message: "ลบสินค้าสำเร็จ" });
    } catch (error) {
      console.error("Error while deleting product:", error);
      res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการลบสินค้า" });
    }
  });
  

// แก้ไขสินค้า
router.post("/update-product/:id", upload.single("image"), async (req, res) => {
    const { id } = req.params;
    const {
      name,
      description,
      price,
      product_type_id,
      category_id,
      stock,
      updatedBy,
      usePromotion, // ใช้โปรโมชันหรือไม่
      discount_rate,
      start_date,
      end_date,
    } = req.body;
    const imagePath = req.file ? req.file.filename : null;
  
    try {
      // ตรวจสอบข้อมูลสินค้า
      if (!name || !price || !product_type_id || !category_id || !stock || !updatedBy) {
        return res.status(400).json({ success: false, message: "กรุณากรอกข้อมูลสินค้าให้ครบถ้วน" });
      }
  
      // อัปเดตข้อมูลสินค้า
      if (imagePath) {
        const [rows] = await db.execute("SELECT image FROM products WHERE product_id = ?", [id]);
        if (rows.length > 0 && rows[0].image) {
          const fullPath = path.join(__dirname, "../uploads", rows[0].image);
          if (fs.existsSync(fullPath)) fs.unlinkSync(fullPath);
        }
  
        await db.execute(
          "UPDATE products SET name = ?, description = ?, price = ?, product_type_id = ?, category_id = ?, stock = ?, image = ?, updated_by = ? WHERE product_id = ?",
          [name, description, price, product_type_id, category_id, stock, imagePath, updatedBy, id]
        );
      } else {
        await db.execute(
          "UPDATE products SET name = ?, description = ?, price = ?, product_type_id = ?, category_id = ?, stock = ?, updated_by = ? WHERE product_id = ?",
          [name, description, price, product_type_id, category_id, stock, updatedBy, id]
        );
      }
  
      // จัดการข้อมูลโปรโมชัน
      if (usePromotion === "true") {
        if (!discount_rate || !start_date || !end_date) {
          return res.status(400).json({ success: false, message: "กรุณากรอกข้อมูลโปรโมชันให้ครบถ้วน" });
        }
  
        // ตรวจสอบว่ามีโปรโมชันอยู่หรือไม่
        const [promotionRows] = await db.execute(
          `
          SELECT p.promotion_id 
          FROM promotions p
          JOIN promotion_products pp ON p.promotion_id = pp.promotion_id
          WHERE pp.product_id = ?
          `,
          [id]
        );
  
        if (promotionRows.length > 0) {
          // อัปเดตโปรโมชันที่มีอยู่
          await db.execute(
            `
            UPDATE promotions
            SET discount_rate = ?, start_date = ?, end_date = ?, updated_by = ?
            WHERE promotion_id = ?
            `,
            [discount_rate, start_date, end_date, updatedBy, promotionRows[0].promotion_id]
          );
        } else {
          // เพิ่มโปรโมชันใหม่และเชื่อมโยงกับสินค้า
          const [newPromotionResult] = await db.execute(
            `
            INSERT INTO promotions (discount_rate, start_date, end_date, created_by) 
            VALUES (?, ?, ?, ?)
            `,
            [discount_rate, start_date, end_date, updatedBy]
          );
  
          await db.execute(
            `
            INSERT INTO promotion_products (promotion_id, product_id)
            VALUES (?, ?)
            `,
            [newPromotionResult.insertId, id]
          );
        }
      } else {
        // หากไม่มีการใช้โปรโมชัน ให้ลบโปรโมชันที่เกี่ยวข้อง
        const [promotionRows] = await db.execute(
          `
          SELECT p.promotion_id 
          FROM promotions p
          JOIN promotion_products pp ON p.promotion_id = pp.promotion_id
          WHERE pp.product_id = ?
          `,
          [id]
        );
  
        if (promotionRows.length > 0) {
          await db.execute(
            `
            DELETE FROM promotion_products WHERE product_id = ?
            `,
            [id]
          );
          await db.execute(
            `
            DELETE FROM promotions WHERE promotion_id = ?
            `,
            [promotionRows[0].promotion_id]
          );
        }
      }
  
      res.status(200).json({ success: true, message: "แก้ไขสินค้าสำเร็จ" });
    } catch (error) {
      console.error("Error while updating product:", error);
      if (req.file) fs.unlinkSync(`uploads/${req.file.filename}`);
      res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการแก้ไขสินค้า" });
    }
  });
  
// ค้นหาสินค้า
router.get("/search-products", async (req, res) => {
  const { query } = req.query; // รับคำค้นหาจาก query string เช่น ?query=ชื่อสินค้า

  try {
    // ตรวจสอบว่ามีคำค้นหาหรือไม่
    if (!query || query.trim() === "") {
      return res.status(400).json({ success: false, message: "กรุณาใส่คำค้นหา" });
    }

    // ดึงข้อมูลสินค้าที่ชื่อ หรือคำอธิบาย ตรงกับคำค้นหา
    const [rows] = await db.execute(
      `
      SELECT p.*, pt.name AS product_type_name, c.name AS category_name
      FROM products p
      LEFT JOIN product_types pt ON p.product_type_id = pt.product_type_id
      LEFT JOIN product_categories c ON p.category_id = c.category_id
      WHERE p.name LIKE ? OR p.description LIKE ? OR c.name LIKE ?
      `,
      [`%${query}%`, `%${query}%`, `%${query}%`]
    );

    // เพิ่ม URL รูปภาพให้สินค้า
    const products = rows.map((row) => ({
      ...row,
      image: row.image ? baseUrl + row.image : null,
    }));

    res.status(200).json(products);
  } catch (error) {
    console.error("Error while searching products:", error);
    res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการค้นหาสินค้า" });
  }
});

  

module.exports = router;
