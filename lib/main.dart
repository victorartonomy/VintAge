import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vintage/config/firebase_options.dart';

import 'app.dart';

void main() async {

  // firebase init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(MyApp());
}
