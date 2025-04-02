import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final double price;

  ProductCard({required this.name, required this.image, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(image, height: 100, width: 100),
          Text(name),
          Text("\$${price.toString()}"),
        ],
      ),
    );
  }
}
