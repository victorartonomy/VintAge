import 'package:flutter/material.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';

class MessagesPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const MessagesPage({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        leading: IconButton(onPressed: openDrawer, icon: const Icon(IconoirIcons.menuScale)),
        title: const Text("Messages"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),

      body: const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconoirIcons.message, size: 100,),
          SizedBox(height: 20,),
          Text("Coming soon..."),
        ],
      )),
    );
  }
}
