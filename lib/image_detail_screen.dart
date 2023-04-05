import 'dart:io';

import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  const ImageDetailScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.file(
              File(imageUrl),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
