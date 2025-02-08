import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import 'item.dart';

class Stock extends ChangeNotifier {
  //list of item menu
  final List<Shirt> _menu = [
    Shirt(
      name: "Man t-shirt",
      description: "Upgrade your wardrobe with our Classic Men's T-Shirt, a perfect blend of comfort, style, and durability. This versatile piece is designed to be your go-to option for any casual occasion.",
      imagePath: ["assets/images/man-shirt1.png","assets/images/man-shirt1.png","assets/images/man-shirt1.png"],
      price: 15,
      category: ShirtCategory.man,
      availableSize: [
        ShirtSize(name: "S"),
        ShirtSize(name: "M"),
        ShirtSize(name: "L"),
      ],
      availableColor: [
        ShirtColor(name: "lightBlue"),
        ShirtColor(name: "white"),
        ShirtColor(name: "orange"),
        ShirtColor(name: "green"),
        ShirtColor(name: "blue"),
      ],
      type: ShirtType.featured,
      stock: 0,
      promotion: 20,
    ),
    Shirt(
      name: "FreeMan t-shirt",
      description: "Upgrade your wardrobe with our Classic Men's T-Shirt, a perfect blend of comfort, style, and durability. This versatile piece is designed to be your go-to option for any casual occasion.",
      imagePath: ["assets/images/man-shirt1.png"],
      price: 15,
      category: ShirtCategory.man,
      availableSize: [
        ShirtSize(name: "S"),
        ShirtSize(name: "M"),
        ShirtSize(name: "L"),
      ],
      availableColor: [
        ShirtColor(name: "lightBlue"),
        ShirtColor(name: "white"),
        ShirtColor(name: "orange"),
        ShirtColor(name: "green"),
        ShirtColor(name: "blue"),
      ],
      type: ShirtType.featured,
      stock: 1,
    ),
    Shirt(
      name: "JapanMan t-shirt",
      description: "Upgrade your wardrobe with our Classic Men's T-Shirt, a perfect blend of comfort, style, and durability. This versatile piece is designed to be your go-to option for any casual occasion.",
      imagePath: ["assets/images/man-shirt1.png"],
      price: 15,
      category: ShirtCategory.man,
      availableSize: [
        ShirtSize(name: "S"),
        ShirtSize(name: "M"),
        ShirtSize(name: "L"),
      ],
      availableColor: [
        ShirtColor(name: "lightBlue"),
        ShirtColor(name: "white"),
        ShirtColor(name: "orange"),
        ShirtColor(name: "green"),
        ShirtColor(name: "blue"),
      ],
      type: ShirtType.featured,
      stock: 1,
    ),
    Shirt(
      name: "Woman t-shirt",
      description: "Upgrade your wardrobe with our Classic Men's T-Shirt, a perfect blend of comfort, style, and durability. This versatile piece is designed to be your go-to option for any casual occasion.",
      imagePath: ["assets/images/woman-shirt1.png"],
      price: 35,
      category: ShirtCategory.man,
      availableSize: [
        ShirtSize(name: "S"),
        ShirtSize(name: "M"),
        ShirtSize(name: "L"),
      ],
      availableColor: [
        ShirtColor(name: "lightBlue"),
        ShirtColor(name: "white"),
        ShirtColor(name: "orange"),
        ShirtColor(name: "green"),
        ShirtColor(name: "blue"),
      ],
      type: ShirtType.bestSell,
      stock: 1,
    ),
    Shirt(
      name: "Kid shirt",
      description: "Upgrade your wardrobe with our Classic Men's T-Shirt, a perfect blend of comfort, style, and durability. This versatile piece is designed to be your go-to option for any casual occasion.",
      imagePath: ["assets/images/kid-shirt1.png"],
      price: 20,
      category: ShirtCategory.man,
      availableSize: [
        ShirtSize(name: "S"),
        ShirtSize(name: "M"),
        ShirtSize(name: "L"),
      ],
      availableColor: [
        ShirtColor(name: "lightBlue"),
        ShirtColor(name: "white"),
        ShirtColor(name: "orange"),
        ShirtColor(name: "green"),
        ShirtColor(name: "blue"),
      ],
      type: ShirtType.promotion,
      stock: 1,
    ),
    // Add more Shirt instances here with different types
  ];

  // get menu
  List<Shirt> get menu => _menu;

  // get featured items
  List<Shirt> get featuredItems => _menu.where((shirt) => shirt.type == ShirtType.featured).toList();

  // get best sell items
  List<Shirt> get bestSellItems => _menu.where((shirt) => shirt.type == ShirtType.bestSell).toList();

  // get promotion items
  List<Shirt> get promotionItems => _menu.where((shirt) => shirt.type == ShirtType.promotion).toList();


}

double calculateDiscountedPrice(double price, double promotion) {
  return price * (1 - promotion / 100); // คำนวณราคาหลังจากลด
}

