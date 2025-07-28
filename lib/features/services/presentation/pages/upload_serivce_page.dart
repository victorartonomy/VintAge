import 'package:flutter/material.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';

class UploadServicePage extends StatefulWidget {
  const UploadServicePage({super.key});

  @override
  State<UploadServicePage> createState() => _UploadServicePageState();
}

class _UploadServicePageState extends State<UploadServicePage> {
  // controller
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactNumberController = TextEditingController();
  final contactEmailController = TextEditingController();
  final timingController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      // appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Upload Service"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(IconoirIcons.upload)),
        ],
      ),

      // body
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // enter details
            Text(
              "Enter Business Details",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
        
            // title
            MyTextField(
              controller: titleController,
              hintText: "Enter title",
              obscureText: false,
            ),
            const SizedBox(height: 10),
        
            // description
            MyTextField(
              controller: descriptionController,
              hintText: "Enter description",
              obscureText: false,
            ),
            const SizedBox(height: 10),
        
            // contact number
            MyTextField(
              controller: contactNumberController,
              hintText: "Enter Contact number",
              obscureText: false,
            ),
            const SizedBox(height: 10),
        
            // contact email
            MyTextField(
              controller: contactEmailController,
              hintText: "Enter Contact email",
              obscureText: false,
            ),
            const SizedBox(height: 10),
        
            // timing
            MyTextField(
              controller: timingController,
              hintText: "Enter timing",
              obscureText: false,
            ),
            const SizedBox(height: 10),
        
            // address
            MyTextField(
              controller: addressController,
              hintText: "Enter address",
              obscureText: false,
            ),
            const SizedBox(height: 10),
        
            // images
            Text(
              "Upload Images",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            MaterialButton(
              onPressed: () {},
              color: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.secondary,
              child: const Text("Upload Images"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
