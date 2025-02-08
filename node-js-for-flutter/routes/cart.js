const express = require("express");
const router = express.Router();
const db = require("../db/connection.js");
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
      เพิ่มสินค้าในตะกร้า
   ========================= */
router.post("/add-to-cart", async (req, res) => {
    const { user_id, product_id, quantity } = req.body;

    if (!user_id || !product_id || quantity < 1) {
        return res.status(400).json({ success: false, message: "ข้อมูลไม่ครบถ้วน" });
    }

    try {
        // ตรวจสอบว่าผู้ใช้มีตะกร้าหรือไม่ ถ้าไม่มีให้สร้างใหม่
        let [cart] = await db.execute("SELECT cart_id FROM carts WHERE user_id = ?", [user_id]);
        let cartId;

        if (cart.length === 0) {
            const [newCart] = await db.execute("INSERT INTO carts (user_id) VALUES (?)", [user_id]);
            cartId = newCart.insertId;
        } else {
            cartId = cart[0].cart_id;
        }

        // ตรวจสอบว่าสินค้าซ้ำในตะกร้าหรือไม่
        const [existingItem] = await db.execute(
            "SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ?", 
            [cartId, product_id]
        );

        if (existingItem.length > 0) {
            // อัปเดตจำนวนสินค้า
            await db.execute(
                "UPDATE cart_items SET quantity = quantity + ? WHERE cart_id = ? AND product_id = ?",
                [quantity, cartId, product_id]
            );
        } else {
            // เพิ่มสินค้าใหม่
            await db.execute(
                "INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (?, ?, ?)",
                [cartId, product_id, quantity]
            );
        }

        res.status(200).json({ success: true, message: "เพิ่มสินค้าในตะกร้าสำเร็จ" });
    } catch (error) {
        console.error("Error adding to cart:", error);
        res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการเพิ่มสินค้าในตะกร้า" });
    }
});

/* =========================
      ดึงข้อมูลตะกร้าของผู้ใช้
   ========================= */
router.get("/get-cart/:user_id", async (req, res) => {
    const { user_id } = req.params;

    try {
        const [cart] = await db.execute("SELECT cart_id FROM carts WHERE user_id = ?", [user_id]);
        if (cart.length === 0) {
            return res.json([]); // ถ้าผู้ใช้ไม่มีตะกร้า ให้ส่งค่าเป็น []
        }

        const cartId = cart[0].cart_id;
        const [cartItems] = await db.execute(
            `SELECT ci.cart_item_id, ci.quantity, p.product_id, p.name, p.price, p.image
            FROM cart_items ci
            JOIN products p ON ci.product_id = p.product_id
            WHERE ci.cart_id = ?`, 
            [cartId]
        );

        // ตรวจสอบและใส่ URL ของรูปภาพ
        const updatedCartItems = cartItems.map(item => ({
            ...item,
            image: item.image ? `${serverIp}${item.image}` : "https://via.placeholder.com/150", // ใช้รูปสำรองถ้าไม่มี
        }));

        res.json(updatedCartItems);
    } catch (error) {
        console.error("Error fetching cart:", error);
        res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการดึงข้อมูลตะกร้า" });
    }
});

/* =========================
      อัปเดตจำนวนสินค้าในตะกร้า
   ========================= */
router.put("/update-cart-item/:cart_item_id", async (req, res) => {
    const { cart_item_id } = req.params;
    const { quantity } = req.body;

    if (!quantity || quantity < 1) {
        return res.status(400).json({ success: false, message: "จำนวนสินค้าต้องไม่น้อยกว่า 1" });
    }

    try {
        await db.execute(
            "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?",
            [quantity, cart_item_id]
        );

        res.status(200).json({ success: true, message: "อัปเดตจำนวนสินค้าสำเร็จ" });
    } catch (error) {
        console.error("Error updating cart item:", error);
        res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการอัปเดตจำนวนสินค้า" });
    }
});

/* =========================
      ลบสินค้าออกจากตะกร้า
   ========================= */
router.delete("/remove-from-cart/:cart_item_id", async (req, res) => {
    const { cart_item_id } = req.params;

    try {
        // เช็คว่ามีสินค้านี้อยู่ในตะกร้าจริงไหม
        const [existingItem] = await db.execute(
            "SELECT * FROM cart_items WHERE cart_item_id = ?",
            [cart_item_id]
        );

        if (existingItem.length === 0) {
            return res.status(404).json({ success: false, message: "ไม่พบสินค้านี้ในตะกร้า" });
        }

        // ถ้ามีอยู่ ให้ลบออก
        await db.execute("DELETE FROM cart_items WHERE cart_item_id = ?", [cart_item_id]);

        res.status(200).json({ success: true, message: "ลบสินค้าจากตะกร้าสำเร็จ" });
    } catch (error) {
        console.error("Error removing item from cart:", error);
        res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการลบสินค้า" });
    }
});

/* =========================
      ลบสินค้าทั้งหมดออกจากตะกร้า
   ========================= */
router.delete("/clear-cart/:user_id", async (req, res) => {
    const { user_id } = req.params;

    try {
        // เช็คว่าผู้ใช้มีตะกร้าหรือไม่
        const [cart] = await db.execute("SELECT cart_id FROM carts WHERE user_id = ?", [user_id]);

        if (cart.length === 0) {
            return res.status(404).json({ success: false, message: "ไม่พบตะกร้าของผู้ใช้" });
        }

        const cartId = cart[0].cart_id;

        // ลบสินค้าทั้งหมดในตะกร้า
        await db.execute("DELETE FROM cart_items WHERE cart_id = ?", [cartId]);

        res.status(200).json({ success: true, message: "ลบสินค้าทั้งหมดในตะกร้าสำเร็จ" });
    } catch (error) {
        console.error("Error clearing cart:", error);
        res.status(500).json({ success: false, message: "เกิดข้อผิดพลาดในการลบตะกร้า" });
    }
});

/* =========================
      ตรวจสอบ API
   ========================= */
router.get("/cart-test", (req, res) => {
    console.log("/api/cart-test was called");
    res.json({ success: true, message: "Cart API is working!" });
});

console.log("cart.js is loaded");

module.exports = router;
