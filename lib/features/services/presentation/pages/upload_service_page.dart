import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/services/domain/entities/service.dart';
import 'package:vintage/features/services/presentation/components/custom_button.dart';
import 'package:vintage/features/services/presentation/cubits/service_states.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../cubits/service_cubit.dart';

class UploadServicePage extends StatefulWidget {
  const UploadServicePage({super.key});

  @override
  State<UploadServicePage> createState() => _UploadServicePageState();
}

class _UploadServicePageState extends State<UploadServicePage> {
  // controller
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final lstServicesController = TextEditingController();
  final websiteController = TextEditingController();
  final contactNumberController = TextEditingController();
  final contactEmailController = TextEditingController();
  final timingController = TextEditingController();
  final addressController = TextEditingController();

  // mobile image picker
  PlatformFile? imagePickedFile;

  // web image picker
  Uint8List? webImage;

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // current user
  AppUser? _currentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    _currentUser = authCubit.currentUser;
  }

  void uploadService() {
    // check if both image and caption are provided
    if (imagePickedFile == null ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        lstServicesController.text.isEmpty ||
        contactNumberController.text.isEmpty ||
        contactEmailController.text.isEmpty ||
        websiteController.text.isEmpty ||
        timingController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide all the fields")),
      );
      return;
    }

    // Generate unique service ID
    final serviceId =
        '${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}';

    // create a new service object
    final newService = Service(
      id: serviceId,
      userId: _currentUser!.uid,
      userName: _currentUser!.name,
      title: titleController.text,
      imagesUrl: [],
      description: descriptionController.text,
      lstServices:
          lstServicesController.text
              .split(',')
              .map((word) => word.trim())
              .where((word) => word.isNotEmpty)
              .toList(),
      contactNumber: contactNumberController.text,
      contactEmail: contactEmailController.text,
      timing: timingController.text,
      address: addressController.text,
      timestamp: DateTime.now(),
      ratings: 0,
      likes: [],
      comments: [],
      userRatings: {},
    );

    // service cubit
    final serviceCubit = context.read<ServiceCubit>();

    // web upload
    if (kIsWeb) {
      serviceCubit.createService(
        newService,
        imageBytesList: [imagePickedFile!.bytes!],
      );
    }
    // mobile upload
    else {
      serviceCubit.createService(
        newService,
        imagePaths: [imagePickedFile!.path!],
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    lstServicesController.dispose();
    websiteController.dispose();
    contactNumberController.dispose();
    contactEmailController.dispose();
    timingController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceCubit, ServiceStates>(
      builder: (context, state) {
        // loading or uploading
        if (state is ServicesLoading || state is ServicesUploading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Build Upload Page
        return buildUploadPage();
      },

      // go to the previous page when the service is uploaded and loaded
      listener: (context, state) {
        if (state is ServicesLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      // appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Upload Service"),
        centerTitle: true,
        actionsPadding: const EdgeInsets.only(right: 8),
        actions: [
          CustomButton(
            icon: IconoirIcons.upload,
            text: "Upload",
            backgroundColor: Colors.green[400],
            foregroundColor: Theme.of(context).colorScheme.secondary,
            onTap: uploadService,
          ),
        ],
      ),

      // body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              hintText: "Enter business title",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // description
            MyTextField(
              controller: descriptionController,
              hintText: "Enter business description",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // Services
            MyTextField(
              controller: lstServicesController,
              hintText: "Enter services (comma separated)",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // contact number
            MyTextField(
              controller: contactNumberController,
              hintText: "Enter contact number",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // contact email
            MyTextField(
              controller: contactEmailController,
              hintText: "Enter contact email",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // Website
            MyTextField(
              controller: websiteController,
              hintText: "Enter website URL",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // timings
            MyTextField(
              controller: timingController,
              hintText: "Enter business hours",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // address
            MyTextField(
              controller: addressController,
              hintText: "Enter business address",
              obscureText: false,
            ),
            const SizedBox(height: 20),

            // images section
            Text(
              "Upload Business Image",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // image picker button
            MaterialButton(
              onPressed: pickImage,
              color: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.secondary,
              child: const Text("Select Image"),
            ),
            const SizedBox(height: 10),

            // image preview
            if (imagePickedFile != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    kIsWeb && webImage != null
                        ? Image.memory(webImage!, fit: BoxFit.cover)
                        : imagePickedFile!.path != null
                        ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                        : const Center(child: Text("Image selected")),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
