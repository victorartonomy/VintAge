import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const MyDrawerTile({super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 30),
        ),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
        onTap: onTap,
      ),
    );
  }
}
