/*

Login Page

On this page, an existing user can login with their:
- email
- pw

--------------------------------------------------
Once the user successfully log in, they will be redirected to home page.

If user doesn't have an account, they can register.

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/presentation/components/my_button.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/responsive/constrained_scaffold.dart';

import '../../../../themes/theme_cubit.dart';
import '../cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  // when login pressed
  void login() {

    // get the string from controller
    final String email = emailController.text;
    final String password = pwController.text;

    // get auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure email and password are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    }

    // else display error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password"),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  static const ColorFilter _inversionColorFilter = ColorFilter.matrix(<double>[
    -1,  0,  0, 0, 255, // Red channel
    0, -1,  0, 0, 255, // Green channel
    0,  0, -1, 0, 255, // Blue channel
    0,  0,  0, 1,   0, // Alpha channel
  ]);

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    bool isDarkMode = themeCubit.isDarkMode;
    return ConstrainedScaffold(

      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
        
                  Container(
                    height: 260,
                    width: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo2.png"),
                        fit: BoxFit.fitWidth,
                        colorFilter: isDarkMode? _inversionColorFilter:null,
                      ),
                    ),
                  ),
        
                  // Icon(
                  //   Icons.lock_open_outlined,
                  //   size: 120,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  SizedBox(height: 25),
        
                  // Welcome
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 25),
        
                  // Email
                  MyTextField(
                    controller: emailController,
                    hintText: "Enter Email",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
        
                  // Password
                  MyTextField(
                    controller: pwController,
                    hintText: "Enter Password",
                    obscureText: true,
                    maxLines: 1,
                  ),
                  SizedBox(height: 25),
        
                  // Login Button
                  MyButton(onTap: login, text: "Login"),
                  SizedBox(height: 10),
        
                  // Go to register button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Not a Member?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages,
                        child: Text(
                          " Register",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
