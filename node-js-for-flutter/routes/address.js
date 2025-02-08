const express = require("express");
const router = express.Router();
const pool = require("../db/connection.js"); // เชื่อมต่อ MySQL database

/* ==========================================
      ดึงรายการที่อยู่ทั้งหมดของผู้ใช้
   ========================================== */
router.get("/addresses", async (req, res) => {
    const userId = req.query.user_id;

    if (!userId) {
        return res.status(400).json({ error: "user_id is required" });
    }

    try {
        const [rows] = await pool.query("SELECT * FROM addresses WHERE user_id = ?", [userId]);
        res.json(rows);
    } catch (error) {
        console.error("Error fetching addresses:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

/* =======================
      เพิ่มที่อยู่ใหม่
   ======================= */
router.post("/addresses", async (req, res) => {
    const {
        user_id, name, street, district, city, province,
        postal_code, phone_number, latitude, longitude,
        address_label, is_default
    } = req.body;

    if (!user_id || !name || !street || !district || !city || !province || !postal_code || !phone_number) {
        return res.status(400).json({ error: "Missing required fields" });
    }

    try {
        // หากเป็นที่อยู่เริ่มต้น ให้รีเซ็ต is_default อันเก่าก่อน
        if (is_default) {
            await pool.query("UPDATE addresses SET is_default = 0 WHERE user_id = ?", [user_id]);
        }

        // เพิ่มที่อยู่ใหม่
        const [result] = await pool.query(
            `INSERT INTO addresses (user_id, name, street, district, city, province, postal_code, phone_number, latitude, longitude, address_label, is_default) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [user_id, name, street, district, city, province, postal_code, phone_number, latitude, longitude, address_label, is_default ? 1 : 0]
        );

        res.json({ message: "Address added successfully", address_id: result.insertId });
    } catch (error) {
        console.error("Error adding address:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

/* =======================
      อัปเดตที่อยู่
   ======================= */
router.put("/addresses/:id", async (req, res) => {
    const addressId = req.params.id;
    const {
        name, street, district, city, province,
        postal_code, phone_number, latitude, longitude,
        address_label, is_default
    } = req.body;

    try {
        if (is_default) {
            // รีเซ็ต is_default ของที่อยู่ทั้งหมดของผู้ใช้
            const [address] = await pool.query("SELECT user_id FROM addresses WHERE address_id = ?", [addressId]);
            if (address.length > 0) {
                await pool.query("UPDATE addresses SET is_default = 0 WHERE user_id = ?", [address[0].user_id]);
            }
        }

        // อัปเดตข้อมูลที่อยู่
        const [updateResult] = await pool.query(
            `UPDATE addresses 
            SET name = ?, street = ?, district = ?, city = ?, province = ?, postal_code = ?, phone_number = ?, latitude = ?, longitude = ?, address_label = ?, is_default = ? 
            WHERE address_id = ?`,
            [name, street, district, city, province, postal_code, phone_number, latitude, longitude, address_label, is_default ? 1 : 0, addressId]
        );

        if (updateResult.affectedRows === 0) {
            return res.status(400).json({ error: "Failed to update address" });
        }

        res.json({ message: "Address updated successfully" });
    } catch (error) {
        console.error("Error updating address:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});

/* =======================
      ลบที่อยู่
   ======================= */
router.delete("/addresses/:id", async (req, res) => {
    const addressId = req.params.id;

    try {
        // ตรวจสอบว่าที่อยู่มีอยู่จริงก่อนลบ
        const [checkAddress] = await pool.query("SELECT * FROM addresses WHERE address_id = ?", [addressId]);

        if (checkAddress.length === 0) {
            return res.status(404).json({ error: "Address not found" });
        }

        // ลบที่อยู่จากฐานข้อมูล
        const [deleteResult] = await pool.query("DELETE FROM addresses WHERE address_id = ?", [addressId]);

        if (deleteResult.affectedRows === 0) {
            return res.status(400).json({ error: "Failed to delete address" });
        }

        res.json({ message: "Address deleted successfully" });
    } catch (error) {
        console.error("Error deleting address:", error);
        res.status(500).json({ error: "Internal Server Error", details: error.message });
    }
});

module.exports = router;
