import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:lumineux_rewards_app/Dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrack/home.dart';
import 'package:swifttrack/inc/base_constants.dart';
import 'package:swifttrack/inc/custom_snack_bar.dart';
// import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String tag = "login-page";
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _username;
  String? _password;

  bool? waitingForApiResponse = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var logo = Hero(
      tag: 'hero',
      child: Center(
        child: CircleAvatar(
          radius: 80,
          // backgroundImage: AssetImage("images/login-logo.png"),
          backgroundColor: Colors.transparent,
          child: Image.asset(
            "images/login-logo.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

    final username = TextFormField(
      textAlign: TextAlign.center,
      autofocus: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: "Username",
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(width: 1, color: Color(0xffd8d8d8)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      onSaved: (String? value) {
        setState(() {
          _username = value;
        });
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Username is required";
        }

        return null;
      },
    );

    final password = TextFormField(
      textAlign: TextAlign.center,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(width: 1, color: Color(0xffd8d8d8)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.green),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      onSaved: (String? value) {
        setState(() {
          _password = value;
        });
      },
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Password is required";
        }

        return null;
      },
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();

          if (isValid) {
            _formKey.currentState!.save();

            setState(() {
              waitingForApiResponse = true;
            });

            var parameters = "/0/${_username!}/${_password!}/1/";

            http.Response response = await http.get(Uri.parse(
                BaseConstants.baseUrl + BaseConstants.getInfoUrl + parameters));

            if (response.statusCode == 200) {
              if (!mounted) return;
              var responseData = jsonDecode(response.body);
              CustomSnackBar(data: responseData["status_msg"])
                  .showSnackBar(context);

              setState(() {
                waitingForApiResponse = false;
              });
              print(responseData);
              if (responseData["status"] == "success") {
                var data = responseData["data"]["account"];
                var prefs = await SharedPreferences.getInstance();
                await prefs.setString('uuid', data["uuid"]);
                await prefs.setString('user_name', data["username"]);
                await prefs.setString('first_name', data["first_name"]);
                await prefs.setString('last_name', data["last_name"]);
                await prefs.setString('email', data["email"]);
                // await prefs.setString('mobile', data["mobile"]);
                // await prefs.setString('points', data["points"]);
                // await prefs.setString('address', data["address"]);
                // await prefs.setString('company', data["comp_name"]);
                // await prefs.setString(
                //     'reward_img', data["img"]["dash_banner_1"]);

                if (!mounted) return;

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const Home();
                    },
                  ),
                  (Route route) => false,
                );
              }
            } else {
              setState(() {
                waitingForApiResponse = false;
              });
            }
          }
        },
        color: const Color(0xffabcc59),
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: waitingForApiResponse == true
          ? const SpinKitRing(
              color: Colors.green,
            )
          : Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: ListView(
                    shrinkWrap: true,
                    // padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    children: [
                      logo,
                      const SizedBox(
                        height: 48.0,
                      ),
                      username,
                      const SizedBox(
                        height: 8.0,
                      ),
                      password,
                      const SizedBox(
                        height: 24.0,
                      ),
                      loginButton,
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       final url =
                      //           Uri.parse(BaseConstants.manageAccountLink);
                      //       if (await canLaunchUrl(url)) {
                      //         await launchUrl(url);
                      //       }
                      //     },
                      //     child: const Text(
                      //       BaseConstants.manageAccountLabel,
                      //       style: TextStyle(
                      //           decoration: TextDecoration.underline,
                      //           color: Colors.blue),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
