/*

Settings Page:

  - Dark mode
  - Blocked User
  - Account Settings

 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/responsive/constrained_scaffold.dart';
import 'package:vintage/themes/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const SettingsPage({super.key, required this.openDrawer});

  // Build UI
  @override
  Widget build(BuildContext context) {

    // theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    // is dark mode
    bool isDarkMode = themeCubit.isDarkMode;

    // Scaffold
    return ConstrainedScaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(onPressed: openDrawer, icon: const Icon(IconoirIcons.menuScale)),
        title: const Text("Settings"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),

      body: Column(
        children: [
          // dark mode
          ListTile(
            title: Text("Dark Mode", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
            trailing: CupertinoSwitch(
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.secondary,
              value: isDarkMode,
              onChanged: (value) {
                themeCubit.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
