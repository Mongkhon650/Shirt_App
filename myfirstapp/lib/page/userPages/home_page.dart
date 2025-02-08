import 'package:flutter/material.dart';
import 'package:myfirstapp/components/userComponents/my_drawer.dart';
import 'package:myfirstapp/components/my_searchfield.dart';
import 'package:myfirstapp/components/my_sliver_app_bar.dart';
import 'package:myfirstapp/components/userComponents/my_categories.dart';
import 'package:myfirstapp/components/userComponents/userServices/dynamic_list_cate.dart';
import 'package:myfirstapp/components/userComponents/search_tile.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(userName: widget.userName),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(),
        ],
        body: Container(
          color: Colors.grey.shade100,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.grey.shade100,
                    child: Column(
                      children: [
                        // ส่วน MySearchfield
                        MySearchfield(
                          onSearchResults: (results) {
                            setState(() {
                              searchResults = results;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // แสดงผลการค้นหาหรือหมวดหมู่สินค้า
                        searchResults.isNotEmpty
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(8.0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  return SearchTile(product: searchResults[index]);
                                },
                              )
                            : Column(
                                children: [
                                  if (searchResults.isEmpty && searchResults.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "ไม่มีสินค้าที่คุณต้องการ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    )
                                  else ...[
                                    const MyCategories(),
                                    const SizedBox(height: 16),
                                    const DynamicListCategories(),
                                  ]
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


