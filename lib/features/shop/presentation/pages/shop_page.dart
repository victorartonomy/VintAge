import 'package:flutter/material.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/services/presentation/components/custom_button.dart';
import 'package:vintage/features/shop/presentation/pages/upload_product_page.dart';

class ShopPage extends StatelessWidget {
  final VoidCallback openDrawer;
  const ShopPage({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: openDrawer,
          icon: const Icon(IconoirIcons.menuScale),
        ),
        centerTitle: true,
        title: const Text('Shop Page'),
        actions: [
          CustomButton(
            icon: IconoirIcons.upload,
            text: "Upload",
            backgroundColor: Colors.green[400],
            foregroundColor: Theme.of(context).colorScheme.secondary,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadProductPage()));
            }
          ),
        ],

        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconoirIcons.shop, size: 100,),
            SizedBox(height: 20,),
            Text('Coming soon...'),
          ],
        ),
      ),
    );
  }
}
