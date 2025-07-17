import 'package:flutter/material.dart';

import '../../../posts/presentation/pages/upload_post_page.dart';
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
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPostPage(),
                  ),
                ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // Drawer
      drawer: MyDrawer(),
    );
  }
}
