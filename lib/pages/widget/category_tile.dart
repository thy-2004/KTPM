import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String name;
  final String image;

  CategoryTile({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(image, height: 50, width: 50),
        Text(name),
      ],
    );
  }
}
