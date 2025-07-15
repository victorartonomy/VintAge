import 'package:flutter/material.dart';

import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // AppBar
      appBar: AppBar(
        // title
        centerTitle: true,
        title: const Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Drawer
      drawer: MyDrawer(),
    );
  }
}
