import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/services/presentation/components/custom_button.dart';
import 'package:vintage/features/shop/domain/entities/product.dart';
import 'package:vintage/features/shop/presentation/cubits/product_states.dart';

import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../cubits/product_cubit.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  // controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final contactNumberController = TextEditingController();
  final contactEmailController = TextEditingController();
  final addressController = TextEditingController();

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

  /*

  Pick file

   */
  // List to store multiple images
  List<PlatformFile> imagePickedFiles = [];
  // List to store web images
  List<Uint8List> webImages = [];

  // Old code for reference
  /*
  // mobile image picker
  PlatformFile? imagePickedFile;
  // web image
  Uint8List? webImage;
  // on pick image clicked
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
  */

  // on pick image clicked
  Future<void> pickImage() async {
    // Don't allow more than 4 images
    if (imagePickedFiles.length >= 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Maximum 4 images allowed")));
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        // Calculate how many more images we can add
        final remainingSlots = 4 - imagePickedFiles.length;
        final newImages = result.files.take(remainingSlots).toList();

        imagePickedFiles.addAll(newImages);

        if (kIsWeb) {
          webImages.addAll(newImages.map((file) => file.bytes!));
        }
      });
    }
  }

  // Remove image at specific index
  void removeImage(int index) {
    setState(() {
      imagePickedFiles.removeAt(index);
      if (kIsWeb) {
        webImages.removeAt(index);
      }
    });
  }

  /*

  Upload Product

   */

  void uploadProduct() {
    // check if required fields are provided
    if (imagePickedFiles.isEmpty ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        contactNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please provide all the required fields (email is optional)",
          ),
        ),
      );
      return;
    }

    // generate unique product id
    final productId =
        '${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}';

    // create a new product object
    final newProduct = Product(
      id: productId,
      userId: _currentUser!.uid,
      userName: _currentUser!.name,
      title: titleController.text,
      imagesUrl: [],
      description: descriptionController.text,
      contactNumber: contactNumberController.text,
      contactEmail: contactEmailController.text,
      address: addressController.text,
      price: priceController.text,
      timestamp: DateTime.now(),
      ratings: 0,
      userRatings: {},
      likes: [],
      comments: [],
    );

    // product cubit
    final productCubit = context.read<ProductCubit>();

    // web upload
    if (kIsWeb) {
      productCubit.createProduct(newProduct, imageBytesList: webImages);
    }
    // mobile upload
    else {
      productCubit.createProduct(
        newProduct,
        imagePaths: imagePickedFiles.map((file) => file.path!).toList(),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    contactNumberController.dispose();
    contactEmailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductStates>(
      builder: (context, state) {
        // loading or uploading
        if (state is ProductLoading || state is ProductUploading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return buildUploadPage();
      },
      // go to the previous page when the product is uploaded and loaded
      listener: (context, state) {
        if (state is ProductLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        title: const Text('Upload Product'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          CustomButton(
            icon: IconoirIcons.upload,
            text: "Upload",
            backgroundColor: Colors.green[400],
            foregroundColor: Theme.of(context).colorScheme.secondary,
            onTap: uploadProduct,
          ),
        ],

        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Title of product
              MyTextField(
                controller: titleController,
                hintText: "Enter product title",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Description of product
              MyTextField(
                controller: descriptionController,
                hintText: "Enter product description",
                obscureText: false,
                maxLines: null,
              ),
              const SizedBox(height: 20),

              // Contact number of product
              MyTextField(
                controller: contactNumberController,
                hintText: "Enter contact number",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Contact email of product (optional)
              MyTextField(
                controller: contactEmailController,
                hintText: "Enter contact email (optional)",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Address of product
              MyTextField(
                controller: addressController,
                hintText: "Enter product address",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Price of product
              MyTextField(
                controller: priceController,
                hintText: "Enter product price",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // images
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: pickImage,
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.secondary,
                      child: Text("Pick Images (${imagePickedFiles.length}/4)"),
                    ),
                  ),
                ],
              ),

              // image previews
              if (imagePickedFiles.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePickedFiles.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            width: 200,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                kIsWeb
                                    ? Image.memory(
                                      webImages[index],
                                      fit: BoxFit.cover,
                                    )
                                    : Image.file(
                                      File(imagePickedFiles[index].path!),
                                      fit: BoxFit.cover,
                                    ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              color: Colors.red,
                              onPressed: () => removeImage(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
