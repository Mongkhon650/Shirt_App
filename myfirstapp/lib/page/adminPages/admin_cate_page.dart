import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Man',
      'image': 'assets/images/man-shirt1.png',
    },
    {
      'name': 'Woman',
      'image': 'assets/images/woman-shirt1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel - ประเภท'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'ประเภทสินค้า',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Category Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // จำนวนคอลัมน์
                  childAspectRatio: 0.8, // อัตราส่วนระหว่างความกว้างและความสูง
                  mainAxisSpacing: 16, // ระยะห่างระหว่างแถว
                  crossAxisSpacing: 16, // ระยะห่างระหว่างคอลัมน์
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    name: category['name'],
                    image: category['image'],
                    onEdit: () {
                      // ฟังก์ชันสำหรับการแก้ไขประเภทสินค้า
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('แก้ไข: ${category['name']}')),
                      );
                    },
                    onDelete: () {
                      // ฟังก์ชันสำหรับการลบประเภทสินค้า
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ลบ: ${category['name']}')),
                      );
                    },
                  );
                },
              ),
            ),
            // Add Category Button
            ElevatedButton(
              onPressed: () {
                // ฟังก์ชันเพิ่มประเภทสินค้า
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เพิ่มประเภทสินค้าใหม่')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Center(
                child: Text(
                  'เพิ่มประเภท',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    Key? key,
    required this.name,
    required this.image,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // รูปภาพ
          Expanded(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          // ชื่อประเภทสินค้า
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // ปุ่มแก้ไขและลบ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.blue),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
