import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfirstapp/components/my_sliver_app_bar.dart';
import 'package:myfirstapp/models/new_cart.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicProductPage extends StatefulWidget {
  final int productId;

  const DynamicProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  _DynamicProductPageState createState() => _DynamicProductPageState();
}

class _DynamicProductPageState extends State<DynamicProductPage> {
  Map<String, dynamic>? _product;
  bool _isLoading = true;
  bool isFavorite = false;
  int userId = 0; // กำหนดค่าเริ่มต้นเป็น 0

  @override
  @override
  void initState() {
    super.initState();
    _fetchUserIdAndProductDetails();
  }

  Future<void> _fetchUserIdAndProductDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id') ?? 0; // ดึง user_id จาก SharedPreferences
    });

    if (userId == 0) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาล็อกอินเพื่อใช้งานฟังก์ชันนี้')),
      );
      return;
    }

    await _fetchProductDetails();
    await _checkFavoriteStatus();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/get-product/${widget.productId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _product = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showQuantityDialog(BuildContext context, int? maxStock) async {
    if (maxStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock information is unavailable.')),
      );
      return;
    }

    int quantity = 1;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('เลือกจำนวนสินค้า'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('สต็อกคงเหลือ: $maxStock'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (quantity < maxStock) {
                            setState(() {
                              quantity++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ยกเลิก'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_product != null) {
                      final maxStock = _product!['stock'] ?? 0;
                      if (maxStock > 0) {
                        Provider.of<NewCart>(context, listen: false).addToCart(
                          CartItem(
                            cartItemId: 0, // ตั้งเป็น 0 เพราะจะได้ค่าใหม่จากเซิร์ฟเวอร์
                            productId: _product!['product_id'],
                            name: _product!['name'],
                            image: _product!['image'] ?? '',
                            price: double.parse(_product!['price'].toString()),
                            quantity: quantity, // ใช้ค่าที่ผู้ใช้เลือก
                          ),
                        );

                        // ✅ ปิด AlertDialog หลังจากเพิ่มสินค้า
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('เพิ่มสินค้าลงในตะกร้าแล้ว!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('สินค้าหมดสต็อก')),
                        );
                      }
                    }
                  },
                  child: const Text('เพิ่มในตะกร้า'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/check-wishlist?user_id=$userId&product_id=${widget.productId}'),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          isFavorite = result['isFavorite'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking favorite status: $e')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    final url = isFavorite
        ? '${AppConfig.baseUrl}/api/remove-from-wishlist'
        : '${AppConfig.baseUrl}/api/add-to-wishlist';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId, 'product_id': widget.productId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isFavorite = !isFavorite;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const MySliverAppBar(),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _product == null
            ? const Center(child: Text('Product not found.'))
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // รูปสินค้า
                Center(
                  child: Image.network(
                    _product?['image'] ?? 'https://via.placeholder.com/300',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // ชื่อสินค้า และ Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _product?['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "Favorite",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ราคาสินค้า
                Text(
                  '฿${_product?['price'] ?? '0.00'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 18),

                // คำอธิบายสินค้า
                Text(
                  _product?['description'] ?? 'ไม่มีคำอธิบายสินค้า',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 125),

                // ปุ่มเพิ่มในตะกร้า
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_product != null) {
                        final maxStock = _product!['stock'] ?? 0;

                        if (maxStock > 0) {
                          _showQuantityDialog(context, maxStock);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('สินค้าหมดสต็อก')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ไม่สามารถโหลดข้อมูลสินค้าได้')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'เพิ่มในตะกร้า',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
