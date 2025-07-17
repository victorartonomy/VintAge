import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/profile/presentation/components/bio_box.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_states.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  // late final AppUser? _currentUser = authCubit.currentUser;

  // on Startup
  @override
  void initState() {
    super.initState();

    // load user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          // get Loaded user
          final user = state.profileUser;

          // Scaffold
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              centerTitle: true,
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user,),
                        ),
                      ),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            body: Column(
              children: [
                // Email
                Text(
                  user.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 25),

                // profile picture
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
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
                      Container(
                        height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
                          ),
                      ),
                ),
                const SizedBox(height: 25),

                // bio
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: BioBox(text: user.bio),
                ),
                const SizedBox(height: 50),

                // posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          );
        }
        // loading
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No profile found...')),
          );
        }
      },
    );
  }
}
