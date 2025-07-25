import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentation/components/my_text_field.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../domain/entities/post.dart';
import '../cubits/post_cubits.dart';
import '../cubits/post_states.dart';

class UploadBlogPage extends StatefulWidget {
  const UploadBlogPage({super.key});

  @override
  State<UploadBlogPage> createState() => _UploadBlogPageState();
}

class _UploadBlogPageState extends State<UploadBlogPage> {

  // mobile image picker
  PlatformFile? imagePickedFile;

  // web image picker
  Uint8List? webImage;

  // text controller
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final captionController = TextEditingController();

  // current user
  AppUser? _currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // get current user
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    _currentUser = authCubit.currentUser;
  }

  // select image
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

  // create and upload the post
  void uploadPost() {
    // check if both image and caption are provided
    if (imagePickedFile == null || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide both image and caption")),
      );
      return;
    }

    // create a new post object
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _currentUser!.uid,
      userName: _currentUser!.name,
      title: titleController.text,
      subtitle: subtitleController.text,
      text: captionController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // post cubit
    final postCubit = context.read<PostCubit>();

    // web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }
    // mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      builder: (context, state) {
        // loading or uploading
        if (state is PostsLoading || state is PostsUploading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Build Upload Page
        return buildUploadPage();
      },

      // go to the previous page when the post is uploaded and loaded
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,

      // app bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Upload Blog"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload button
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload)),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // upload image
              // image preview for web
              if (kIsWeb && webImage != null) Image.memory(webImage!),

              // image preview for mobile
              if (!kIsWeb && imagePickedFile != null)
                SizedBox(
                  height: 430,
                  width: double.infinity,
                  child: Image.file(File(imagePickedFile!.path!)),
                ),

              // button to pick image
              MaterialButton(
                onPressed: pickImage,
                color: Theme.of(context).colorScheme.primary,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 25),

              // title
              MyTextField(
                controller: titleController,
                hintText: "Enter title",
                obscureText: false,
              ),
              const SizedBox(height: 25),

              // title
              MyTextField(
                controller: subtitleController,
                hintText: "Enter Subtitle",
                obscureText: false,
              ),
              const SizedBox(height: 25),

              // body
              // MyTextField(
              //   controller: captionController,
              //   hintText: "Enter description",
              //   obscureText: false,
              // ),

              TextField(
                controller: captionController,
                maxLines: null,
                decoration: InputDecoration(

                  fillColor: Theme.of(context).colorScheme.secondary,
                  filled: true,

                  // unselected border
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  // selected border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  // hint text
                  hintText: "Enter Description",
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
