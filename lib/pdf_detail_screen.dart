import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfDetailScreen extends StatelessWidget {
  final String pdfUrl;
  final String pdfType;
  const PdfDetailScreen(
      {super.key, required this.pdfUrl, required this.pdfType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: GestureDetector(
        child: Center(
          child: pdfType == "internal"
              ? SfPdfViewer.file(
                  File(pdfUrl),
                )
              : SfPdfViewer.network(pdfUrl),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
