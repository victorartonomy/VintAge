import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/posts/domain/entities/post.dart';
import 'package:vintage/features/posts/presentation/cubits/post_states.dart';

import '../cubits/post_cubits.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image picker
  PlatformFile? imagePickedFile;

  // web image picker
  Uint8List? webImage;

  // text controller
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

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // BLOC Consumer -> builder + Listener
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
    // Scaffold
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.surface,

      // App Bar
      appBar: AppBar(
        title: const Text("Upload Post"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload button
          IconButton(onPressed: uploadPost, icon: const Icon(Icons.upload)),
        ],
      ),

      // body
      body: Center(
        child: Column(
          children: [
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

            // caption text box
            MyTextField(
              controller: captionController,
              hintText: "Enter Caption",
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }
}
