import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfDetailScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfDetailScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: GestureDetector(
        child: Center(
          child: SfPdfViewer.file(
            File(pdfUrl),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
