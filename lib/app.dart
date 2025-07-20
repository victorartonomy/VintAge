import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/data/firebase_auth_repo.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_states.dart';
import 'package:vintage/features/search/presentation/cubits/search_cubit.dart';
import 'package:vintage/themes/theme_cubit.dart';
import 'features/authentication/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/posts/data/firebase_post_repo.dart';
import 'features/posts/presentation/cubits/post_cubits.dart';
import 'features/profile/data/firebase_profile_repo.dart';
import 'features/profile/presentation/cubits/profile_cubit.dart';
import 'features/search/data/firebase_search_repo.dart';
import 'features/storage/data/firebase_storage_repo.dart';

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
  // auth repos
  final firebaseAuthRepo = FirebaseAuthRepo();

  // profile repos
  final firebaseProfileRepo = FirebaseProfileRepo();

  // storage repos
  final firebaseStorageRepo = FirebaseStorageRepo();

  // posts repos
  final firebasePostsRepo = FirebasePostRepo();

  // search repos
  final firebaseSearchRepo = FirebaseSearchRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide cubit to app
    return MultiBlocProvider(
      providers: [

        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create:
              (context) => ProfileCubit(
                profileRepo: firebaseProfileRepo,
                storageRepo: firebaseStorageRepo,
              ),
        ),

        // post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(postRepo: firebasePostsRepo, storageRepo: firebaseStorageRepo),
        ),

        // search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),

        // theme cubit
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),


      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ),
      )
    );
  }
}
