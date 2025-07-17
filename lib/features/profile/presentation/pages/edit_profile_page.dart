import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image picker
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  // bio text controller
  final bioTextController = TextEditingController();

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

  // update profile button pressed
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    // prepare images
    final String uid = widget.user.uid;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    // only update profile if there is something to update
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        newBio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes,
      );
    }
    // nothing to update : goto previous page
    else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // profile loading
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return buildEditPage();
        }

        // profile error

        // edit form
        // return buildEditPage();
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // save button
          IconButton(onPressed: updateProfile, icon: const Icon(Icons.upload)),
        ],
      ),

      body: Column(
        children: [
          // Profile Picture
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  // display selected image for mobile
                  (!kIsWeb && imagePickedFile != null)
                      ? Image.file(File(imagePickedFile!.path!), fit: BoxFit.cover,)
                      :
                      // display selected image for web
                      (kIsWeb && webImage != null)
                      ? Image.memory(webImage!, fit: BoxFit.cover,)
                      :
                      // display image selected -> display existing profile pic
                      CachedNetworkImage(
                        imageUrl: widget.user.profileImageUrl,
                        // loading
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),

                        // error -> failed to load
                        errorWidget:
                            (context, url, error) => Icon(
                              Icons.person,
                              size: 72,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                        // loaded
                        imageBuilder:
                            (context, imageProvider) =>
                                Image(image: imageProvider),
                        fit: BoxFit.cover,
                      ),
            ),
          ),
          const SizedBox(height: 25),

          // pick image button
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Theme.of(context).colorScheme.primary,
              child: const Text("Pick Image"),
            ),
          ),

          // bio
          const Text("Bio"),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController,
              hintText: "Enter New Bio",
              obscureText: false,
            ),
          ),
        ],
      ),
    );
  }
}
