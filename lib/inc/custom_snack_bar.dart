import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String data;
  const CustomSnackBar({super.key, required this.data});

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          data,
          style: const TextStyle(fontSize: 17.0),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 20,
        bottom: 20,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
