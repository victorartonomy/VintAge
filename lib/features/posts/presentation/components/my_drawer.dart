import 'package:flutter/material.dart';
import 'package:vintage/features/posts/presentation/components/my_drawer_tile.dart';

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
                SizedBox(height: 100,),

                Icon(
                  Icons.flutter_dash,
                  size: 120,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 100),

                // home tile
                MyDrawerTile(title: "Home", icon: Icons.home, onTap: () => Navigator.of(context).pop(),),

                // profile tile
                MyDrawerTile(title: "Profile", icon: Icons.person, onTap: (){},),

                // search tile
                MyDrawerTile(title: "Search", icon: Icons.search, onTap: (){},),

                // settings tile
                MyDrawerTile(title: "Settings", icon: Icons.settings, onTap: (){},),
              ],
            ),

            // logout tile
            MyDrawerTile(title: "Logout", icon: Icons.logout, onTap: (){},),
          ],
        ),
      ),
    );
    // Logo
  }
}
