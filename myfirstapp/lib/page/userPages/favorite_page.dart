import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> favoriteItems = [];
  int userId = 0;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndFavorites();
  }

  Future<void> _fetchUserIdAndFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id') ?? 0;
    });

    if (userId == 0) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      return;
    }

    await _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/get-wishlist?user_id=$userId'), // ✅ เปลี่ยน API
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print("API Response: $result");

        if (result['success'] == true && result.containsKey('wishlist')) {
          setState(() {
            favoriteItems = result['wishlist'];
            isLoading = false;
            hasError = false;
          });
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch Favorites Error: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> _removeFromFavorites(int productId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/remove-from-wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId, 'product_id': productId}),
      );

      if (response.statusCode == 200) {
        await _fetchFavorites(); //
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ลบสินค้าออกจาก Wishlist สำเร็จ")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาดในการลบสินค้า")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite")), //
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text("เกิดข้อผิดพลาดในการโหลดข้อมูล"))
          : favoriteItems.isEmpty
          ? Center(child: Text("ไม่มีสินค้าใน Favorite ของคุณ"))
          : RefreshIndicator(
        onRefresh: _fetchFavorites,
        child: ListView.builder(
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            final item = favoriteItems[index];

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Image.network(
                  item['image'], //
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
                title: Text(item['name']),
                subtitle: Text("฿${item['price']}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeFromFavorites(item['product_id']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
