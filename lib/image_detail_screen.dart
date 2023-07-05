import 'dart:io';

import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String imageType;

  const ImageDetailScreen(
      {super.key, required this.imageUrl, required this.imageType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: imageType == "internal"
                ? Image.file(
                    File(imageUrl),
                  )
                : Image.network(imageUrl),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
