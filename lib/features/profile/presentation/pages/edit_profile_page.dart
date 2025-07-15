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
  final TextEditingController bioTextController = TextEditingController();

  // update profile button pressed
  void updateProfile() async {

    final profileCubit = context.read<ProfileCubit>();

    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(uid: widget.user.uid, newBio: bioTextController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // profile loading
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
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

          // bio
          const Text("Bio"),
          const SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(controller: bioTextController, hintText: "Enter New Bio", obscureText: false),
          ),
        ],
      ),
    );
  }
}
