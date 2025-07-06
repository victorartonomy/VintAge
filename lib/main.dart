import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vintage/features/authentication/presentation/pages/login_page.dart';
import 'package:vintage/firebase_options.dart';
import 'package:vintage/themes/light_mode.dart';

void main() async {

  // firebase init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: LoginPage(),
    );
  }
}
