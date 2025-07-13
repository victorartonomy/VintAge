/*

AuthPage: This page determines whether to show login or register page

 */

import 'package:flutter/material.dart';
import 'package:vintage/features/authentication/presentation/pages/login_page.dart';
import 'package:vintage/features/authentication/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  // initially show login page
  bool showLoginPage = true;

  // toggle between pages
  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(togglePages: toggleScreens);
    } else {
      return RegisterPage(togglePages: toggleScreens);
    }
  }
}
