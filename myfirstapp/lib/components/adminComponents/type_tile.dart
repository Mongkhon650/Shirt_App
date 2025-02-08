import 'package:flutter/material.dart';
import 'package:myfirstapp/models/type_card.dart';

class TypeTile extends StatelessWidget {
  final TypeModel type;

  TypeTile({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5), // ปรับระยะห่างระหว่างแต่ละ Container
      height: 150,
      width: 120, // ปรับความกว้างของ Container ให้เหมาะสมกับรูปภาพ
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              type.imageAsset!,
              fit: BoxFit.cover,
              width: 120,
              height: 80, // ปรับความสูงของรูปภาพให้เหมาะสมกับ Container
            ),
          ),
          Container(
            width: 120,
            height: 80,
            alignment: Alignment.center,
            child: Text(
              type.typeName!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}