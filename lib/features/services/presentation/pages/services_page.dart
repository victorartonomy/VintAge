import 'package:flutter/material.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/services/presentation/pages/upload_serivce_page.dart';

class ServicesPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const ServicesPage({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        leading: IconButton(
          onPressed: openDrawer,
          icon: const Icon(IconoirIcons.menuScale),
        ),
        title: const Text("Services"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadServicePage(),
                  ),
                ),
            icon: const Icon(IconoirIcons.plus),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconoirIcons.suitcase, size: 100),
            const SizedBox(height: 30),
            Text("Services Coming Soon"),
          ],
        ),
      ),
    );
  }
}
