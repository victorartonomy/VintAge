import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/data/firebase_auth_repo.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_states.dart';
import 'package:vintage/themes/light_mode.dart';
import 'features/authentication/presentation/pages/auth_page.dart';
import 'features/posts/presentation/pages/home_page.dart';

/*

App - root level

------------------------------------------------

Repositories: for database
  - firebase

BLoc Providers: for state management
  - auth
  - profile
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page (login/register)
  - authenticated -> home page

 */

class MyApp extends StatelessWidget {

  // auth repo
  final authRepo = FirebaseAuthRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // provide cubit to app
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {

            // unauthenticated
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            // authenticated
            if (authState is Authenticated) {
              return const HomePage();
            }

            // loading...
            else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
          },

          // show error message
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
        )
      ),
    );
  }
}