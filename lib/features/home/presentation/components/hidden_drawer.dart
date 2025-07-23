import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/home/presentation/components/drawer_items.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import 'drawer_item.dart';

class HiddenDrawer extends StatefulWidget {
  final ValueChanged<DrawerItem> onSelectedItemChanged;

  const HiddenDrawer({super.key, required this.onSelectedItemChanged});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  // get First name
  String getFirstName(String fullName) {
    if (fullName.isEmpty) return '';

    // Split the name by whitespace
    List<String> parts = fullName.trim().split(' ');

    // Return the first part as first name
    return parts[0];
  }

  @override
  Widget build(BuildContext context) {

    // profile
    final user = context.read<AuthCubit>().currentUser;
    String firstName = getFirstName(user!.name);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          GestureDetector(
            onTap: () => widget.onSelectedItemChanged(DrawerItems.profile),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 80),
              child: Row(
                children: [
                  Icon(Icons.person, size: 40),
                  SizedBox(width: 20),
                  Text('Welcome, $firstName', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ),
          SizedBox(height: 200),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                buildDrawerItems(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children:
        DrawerItems.all
            .map(
              (item) => ListTile(
                leading: Icon(item.icon),
                title: Text(item.title),
                onTap: () => widget.onSelectedItemChanged(item),
              ),
            )
            .toList(),
  );
}
