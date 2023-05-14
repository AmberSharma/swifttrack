import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:swifttrack/home.dart';
import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:swifttrack/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // await Hive.openBox("userBox");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const SwiftTrackApp());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const SwiftTrackApp()));
}

class SwiftTrackApp extends StatelessWidget {
  const SwiftTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const InitScreen();
  }
}

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: <String, WidgetBuilder>{
      //   Login.tag: (BuildContext context) => const Login(),
      //   Dashboard.tag: (BuildContext context) => const Dashboard(),
      // },
      theme: ThemeData(fontFamily: 'Open Sans'),
      home: const SplashScreen(),
    );
  }
}
