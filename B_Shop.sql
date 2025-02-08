-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               11.6.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for clothingstore
CREATE DATABASE IF NOT EXISTS `clothingstore` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `clothingstore`;

-- Dumping structure for table clothingstore.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `profile_image` blob DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`account_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.accounts: ~3 rows (approximately)
REPLACE INTO `accounts` (`account_id`, `name`, `email`, `password`, `phone_number`, `profile_image`, `is_admin`, `created_at`, `updated_at`) VALUES
	(1, 'cat', 'cat', '$2a$10$m9n88r.bMw0DkpSRc0a6OOUO.QA1f.OHzKGHpcakVN6PwwvBxelRG', NULL, NULL, 1, '2025-01-19 14:33:51', '2025-01-20 05:25:46'),
	(2, 'a', 'a', '$2a$10$umZ917JROcjnFXgurpminubKm/Tbmy/lRn6GZhXAMV19pElKVUquS', NULL, NULL, 0, '2025-01-21 07:44:02', '2025-01-21 07:44:02'),
	(3, 'b', 'b', '$2a$10$pf2JdMAa9dbTS7B6p2B9XOgOzt7OvdZFLNvpsBptBlwHOxsnOUwi.', NULL, NULL, 0, '2025-02-07 12:43:21', '2025-02-07 12:43:21'),
	(4, 'c', 'c', '$2a$10$Lyzbk4XZSFBpDOoGQ.3zqexHTpAd/jnFmcrKWTcY575tdOLi5gunG', NULL, NULL, 0, '2025-02-08 07:18:04', '2025-02-08 07:18:04');

-- Dumping structure for table clothingstore.addresses
CREATE TABLE IF NOT EXISTS `addresses` (
  `address_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `street` varchar(255) NOT NULL,
  `district` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `province` varchar(100) NOT NULL,
  `postal_code` varchar(10) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `address_label` varchar(50) DEFAULT 'บ้าน',
  `is_default` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`address_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table clothingstore.addresses: ~5 rows (approximately)
REPLACE INTO `addresses` (`address_id`, `user_id`, `name`, `street`, `district`, `city`, `province`, `postal_code`, `phone_number`, `latitude`, `longitude`, `created_at`, `updated_at`, `address_label`, `is_default`) VALUES
	(2, 3, 'sdadsa', '323 Si Lom Rd', 'Khet Bang Rak', 'dasdad', 'Krung Thep Maha Nakhon', '10500', '4755', 13.72690830, 100.53145670, '2025-02-07 16:03:27', '2025-02-07 16:03:27', 'บ้าน', 1),
	(8, 2, 'dasdadad', '323 Si Lom Rd', 'Khet Bang Rak', 'dasdsadasd', 'Krung Thep Maha Nakhon', '10500', '31313123', 13.72690830, 100.53145670, '2025-02-07 16:28:42', '2025-02-07 16:28:42', 'บ้าน', 1),
	(9, 2, 'My Home', '123 Main Street', 'Bang Rak', 'Bangkok', 'Bangkok', '10100', '0123456789', 13.75000000, 100.50000000, '2025-02-07 16:29:19', '2025-02-07 16:29:19', 'บ้าน', 1),
	(10, 2, 'Hp', '323 Si Lom Rd', 'Khet Bang Rak', 'DEDE', 'Krung Thep Maha Nakhon', '10500', '1234', 13.72690830, 100.53145670, '2025-02-08 06:09:18', '2025-02-08 06:09:18', 'ที่ทำงาน', 0),
	(11, 2, 'aa', '323 Si Lom Rd', 'Khet Bang Rak', 'aa', 'Krung Thep Maha Nakhon', '10500', '25', 13.72690830, 100.53145670, '2025-02-08 06:11:18', '2025-02-08 06:11:18', 'บ้าน', 0);

-- Dumping structure for table clothingstore.carts
CREATE TABLE IF NOT EXISTS `carts` (
  `cart_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`cart_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table clothingstore.carts: ~1 rows (approximately)
REPLACE INTO `carts` (`cart_id`, `user_id`, `created_at`) VALUES
	(1, 2, '2025-02-08 08:02:39');

-- Dumping structure for table clothingstore.cart_items
CREATE TABLE IF NOT EXISTS `cart_items` (
  `cart_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`cart_item_id`),
  KEY `cart_id` (`cart_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`cart_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table clothingstore.cart_items: ~0 rows (approximately)

-- Dumping structure for table clothingstore.orderdetails
CREATE TABLE IF NOT EXISTS `orderdetails` (
  `order_detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_detail_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.orderdetails: ~0 rows (approximately)

-- Dumping structure for table clothingstore.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` varchar(50) NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.orders: ~0 rows (approximately)

-- Dumping structure for table clothingstore.payments
CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.payments: ~0 rows (approximately)

-- Dumping structure for table clothingstore.products
CREATE TABLE IF NOT EXISTS `products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `product_type_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `product_type_id` (`product_type_id`),
  KEY `category_id` (`category_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`product_type_id`) REFERENCES `product_types` (`product_type_id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`),
  CONSTRAINT `products_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `accounts` (`account_id`),
  CONSTRAINT `products_ibfk_4` FOREIGN KEY (`updated_by`) REFERENCES `accounts` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.products: ~2 rows (approximately)
REPLACE INTO `products` (`product_id`, `name`, `description`, `price`, `product_type_id`, `category_id`, `stock`, `image`, `created_by`, `updated_by`) VALUES
	(1, 'A', 'A', 20.00, 1, 1, 15, 'image-1737445354930-163162546.jpg', 1, NULL),
	(2, 'A', 's', 5.00, 1, 1, 15, 'image-1737445409843-890524812.jpg', 1, NULL);

-- Dumping structure for table clothingstore.product_categories
CREATE TABLE IF NOT EXISTS `product_categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `name` (`name`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `product_categories_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `accounts` (`account_id`),
  CONSTRAINT `product_categories_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `accounts` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.product_categories: ~0 rows (approximately)
REPLACE INTO `product_categories` (`category_id`, `name`, `created_by`, `updated_by`) VALUES
	(1, 'Best Sell', 1, NULL);

-- Dumping structure for table clothingstore.product_types
CREATE TABLE IF NOT EXISTS `product_types` (
  `product_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_type_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `product_types_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `accounts` (`account_id`),
  CONSTRAINT `product_types_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `accounts` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.product_types: ~0 rows (approximately)
REPLACE INTO `product_types` (`product_type_id`, `name`, `image`, `created_by`, `updated_by`) VALUES
	(1, 'Man', 'image-1737445280800-351818608.jpg', 1, NULL);

-- Dumping structure for table clothingstore.promotions
CREATE TABLE IF NOT EXISTS `promotions` (
  `promotion_id` int(11) NOT NULL AUTO_INCREMENT,
  `discount_rate` decimal(5,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`promotion_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `promotions_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `accounts` (`account_id`),
  CONSTRAINT `promotions_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `accounts` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.promotions: ~0 rows (approximately)
REPLACE INTO `promotions` (`promotion_id`, `discount_rate`, `start_date`, `end_date`, `created_by`, `updated_by`) VALUES
	(1, 10.00, '2025-01-21', '2025-01-22', 1, NULL);

-- Dumping structure for table clothingstore.promotion_products
CREATE TABLE IF NOT EXISTS `promotion_products` (
  `promotion_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`promotion_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `promotion_products_ibfk_1` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`) ON DELETE CASCADE,
  CONSTRAINT `promotion_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.promotion_products: ~0 rows (approximately)
REPLACE INTO `promotion_products` (`promotion_id`, `product_id`) VALUES
	(1, 2);

-- Dumping structure for table clothingstore.wishlist
CREATE TABLE IF NOT EXISTS `wishlist` (
  `wishlist_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`wishlist_id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`account_id`),
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table clothingstore.wishlist: ~3 rows (approximately)
REPLACE INTO `wishlist` (`wishlist_id`, `user_id`, `product_id`) VALUES
	(3, 3, 1),
	(5, 2, 2),
	(6, 2, 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
