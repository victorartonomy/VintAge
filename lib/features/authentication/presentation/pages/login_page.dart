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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(
                  Icons.lock_open_outlined,
                  size: 120,
                  color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
