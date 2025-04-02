import 'package:flutter/material.dart';
import 'package:shopping_app/pages/widget/category_tile.dart';

import 'package:shopping_app/pages/widget/support_widget.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_pref.dart';

import '../pages/widget/product_card.dart';

class WebHome extends StatefulWidget {
  const WebHome({super.key});

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  String? name, image;
  List categories = [
    {"icon": "images/headphoneicon.png", "name": "Headphones"},
    {"icon": "images/laptopicon.png", "name": "Laptop"},
    {"icon": "images/watchicon.png", "name": "Watch"},
    {"icon": "images/tvicon.png", "name": "TV"},
  ];

  List<dynamic> productList = []; // Danh sách sản phẩm

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchProducts(); // Gọi API để lấy sản phẩm
  }

  Future<void> _loadUserData() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  Future<void> _fetchProducts() async {
    try {
      List products = await DatabaseMethods().getAllProducts();
      setState(() {
        productList = products;
      });
    } catch (e) {
      print("🔥 Lỗi tải sản phẩm: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping App Web",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CircleAvatar(
              backgroundImage: image != null
                  ? AssetImage(image!)
                  : const AssetImage("images/boy.jpg"),
              radius: 25,
            ),
          ),
        ],
      ),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hey, $name!",
                style: AppWidget.boldTextFeildStyle()
                    .copyWith(fontSize: 26)),
            const Text("Welcome to our shop",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Search Products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            Text("Categories",
                style: AppWidget.semiboldTextFeildStyle()
                    .copyWith(fontSize: 22)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: categories
                  .map((category) => CategoryTile(
                  image: category["icon"], name: category["name"]))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text("All Products",
                style: AppWidget.semiboldTextFeildStyle()
                    .copyWith(fontSize: 22)),
            const SizedBox(height: 10),
            Expanded(
              child: productList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  var product = productList[index];
                  return ProductCard(
                    image: product['image'] ??
                        "images/default_product.png",
                    name: product['name'] ?? "No Name",
                    price: double.tryParse(product['price'].toString()) ?? 0.0,

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
