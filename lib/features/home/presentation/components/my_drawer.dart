import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/search/presentation/pages/search_page.dart';
import 'package:vintage/features/settings/presentation/pages/settings_page.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo and tiles
            Column(
              children: [
                SizedBox(height: 100),

                Icon(
                  Icons.flutter_dash,
                  size: 120,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 100),

                // home tile
                MyDrawerTile(
                  title: "Home",
                  icon: Icons.home,
                  onTap: () => Navigator.of(context).pop(),
                ),

                // profile tile
                MyDrawerTile(
                  title: "Profile",
                  icon: Icons.person,
                  onTap: () {
                    // pop menu
                    Navigator.of(context).pop();

                    // get current user id
                    final user = context.read<AuthCubit>().currentUser;
                    String uid = user!.uid;

                    // navigate to profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(uid: uid),
                      ),
                    );
                  },
                ),

                // search tile
                MyDrawerTile(
                  title: "Search",
                  icon: Icons.search,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      ),
                ),

                // settings tile
                MyDrawerTile(
                  title: "Settings",
                  icon: Icons.settings,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  ),
                ),
              ],
            ),

            // logout tile
            MyDrawerTile(
              title: "Logout",
              icon: Icons.logout,
              onTap: () {
                context.read<AuthCubit>().logout();
              },
            ),
          ],
        ),
      ),
    );
    // Logo
  }
}
