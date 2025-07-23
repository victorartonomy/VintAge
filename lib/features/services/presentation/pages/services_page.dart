import 'package:flutter/material.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' show Suitcase;

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Suitcase(),
            Text("Services Page"),
          ],
        ),),
    );
  }
}
