import 'dart:async';
import 'package:flutter/material.dart';
import 'package:swifttrack/login.dart';
import 'package:swifttrack/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var uuidValue = "";

  @override
  void initState() {
    super.initState();

    screenRedirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          "images/splash.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void screenRedirect() async {
    var prefs = await SharedPreferences.getInstance();
    uuidValue = "";
    if (prefs.getString("uuid") != null) {
      uuidValue = prefs.getString("uuid")!;
    }

    Timer(const Duration(seconds: 3), () {
      if (uuidValue.isNotEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    });
  }
}
