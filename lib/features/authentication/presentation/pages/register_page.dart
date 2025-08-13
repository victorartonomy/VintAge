/*

Register Page

On this page, an existing user can register with their:
- email
- name
- pw

--------------------------------------------------
Once the user successfully log in, they will be redirected to home page.

If user doesn't have an account, they can register.

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/presentation/components/my_button.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';

import '../../../../responsive/constrained_scaffold.dart';
import '../../../../themes/theme_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  // Register function
  void register() {
    // String
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String pw = pwController.text.trim();
    String confirmPw = confirmPwController.text.trim();

    // authCubit
    final authCubit = context.read<AuthCubit>();

    // ensure fields arnt empty
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty) {
      // if passwords match
      if (pw == confirmPw) {
        authCubit.register(email, pw, name);
      }
      // if passwords don't match
      else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      }
    }
    // if fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields must be filled")),
      );
    }
  }

  // dispose controllers
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
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
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
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
                  //   Icons.flutter_dash,
                  //   size: 120,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  // SizedBox(height: 10),

                  Text(
                    "A Kare Nursing Services initiative",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold
                    ),
                  ),
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

                  // Name
                  MyTextField(
                    controller: nameController,
                    hintText: "Enter Name",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

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
                  SizedBox(height: 10),

                  // Confirm Password
                  MyTextField(
                    controller: confirmPwController,
                    hintText: "Re-Enter Password",
                    obscureText: true,
                    maxLines: 1,
                  ),
                  SizedBox(height: 25),

                  // Register Button
                  MyButton(onTap: register, text: "Register"),
                  SizedBox(height: 10),

                  // Go to register button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Already a Member?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages,
                        child: Text(
                          " Login",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
