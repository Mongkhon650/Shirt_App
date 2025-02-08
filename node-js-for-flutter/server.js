const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const path = require("path");
const os = require("os");

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// กำหนด Path สำหรับให้บริการไฟล์ในโฟลเดอร์ uploads
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Import Routes
const registerRoutes = require("./routes/auth/register.js");
const userLoginRoutes = require("./routes/auth/login.js");
const productTypeRoutes = require("./routes/p_type.js");
const categoryTypeRoutes = require("./routes/p_cate.js");
const productRoutes = require("./routes/product.js");
const userRoutes = require("./routes/user");
const dashboardRoutes = require("./routes/dashboard");
const wishlistRoutes = require("./routes/wishlist");
const addressRoutes = require("./routes/address");
const cartRoutes = require("./routes/cart.js");


// Register API Routes
console.log("\nLoading API Routes...");

const routes = [
  { path: "/api/auth", route: registerRoutes },
  { path: "/api/auth", route: userLoginRoutes },
  { path: "/api", route: productTypeRoutes },
  { path: "/api", route: categoryTypeRoutes },
  { path: "/api", route: productRoutes },
  { path: "/api", route: userRoutes },
  { path: "/api", route: wishlistRoutes },
  { path: "/api", route: dashboardRoutes },
  { path: "/api", route: addressRoutes },
  { path: "/api", route: cartRoutes },
];

routes.forEach(({ path, route }) => {
  app.use(path, route);
  console.log(`Route Registered: ${path}`);
});

console.log("\nAll API Routes Loaded Successfully!");

// กำหนดค่า Network สำหรับ IP Address
const networkInterfaces = os.networkInterfaces();
const addresses = Object.values(networkInterfaces)
  .flat()
  .filter((iface) => iface.family === "IPv4" && !iface.internal)
  .map((iface) => iface.address);

const serverIp = addresses.length > 0 ? addresses[0] : "localhost";

// Start Server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`\nServer running on: http://${serverIp}:${PORT}`);
});
