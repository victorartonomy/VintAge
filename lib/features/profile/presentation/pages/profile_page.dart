import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/posts/presentation/components/post_tile.dart';
import 'package:vintage/features/posts/presentation/cubits/post_cubits.dart';
import 'package:vintage/features/posts/presentation/cubits/post_states.dart';
import 'package:vintage/features/profile/presentation/components/bio_box.dart';
import 'package:vintage/features/profile/presentation/components/follow_button.dart';
import 'package:vintage/features/profile/presentation/components/profile_stats.dart';
import 'package:vintage/features/profile/presentation/pages/follower_page.dart';
import '../../../authentication/domain/entities/app_user.dart';
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
  late final AppUser? _currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

  // on Startup
  @override
  void initState() {
    super.initState();

    // load user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  /*

  Follow / UnFollow button

   */

  void followButtonPressed() {
    final profileState = profileCubit.state;

    if (profileState is! ProfileLoaded) {
      return;
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(_currentUser?.uid);

    // optimistically update the UI
    setState(() {
      // unfollow
      if (isFollowing) {
        profileUser.followers.remove(_currentUser!.uid);
      }
      // follow
      else {
        profileUser.followers.add(_currentUser!.uid);
      }
    });

    // perform actual toggle
    profileCubit.toggleFollow(_currentUser!.uid, widget.uid).catchError((
      error,
    ) {
      // revert optimistically updated UI
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.followers.add(_currentUser.uid);
        }
        // follow
        else {
          profileUser.followers.remove(_currentUser.uid);
        }
      });
    });
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // is own profile
    bool isOwnProfile = (widget.uid == authCubit.currentUser?.uid);

    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          // get Loaded user
          final user = state.profileUser;

          // Scaffold
          return Scaffold(

            backgroundColor: Theme.of(context).colorScheme.surface,

            // app bar
            appBar: AppBar(
              title: Text(user.name),
              centerTitle: true,
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                // Edit button
                if (isOwnProfile)
                  IconButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(user: user),
                          ),
                        ),
                    icon: const Icon(Icons.edit),
                  ),
              ],
            ),

            // profile view
            body: ListView(
              children: [
                // Email
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // profile picture
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  // loading
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),

                  // error -> failed to load
                  errorWidget:
                      (context, url, error) => Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                  // loaded
                  imageBuilder:
                      (context, imageProvider) => Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 25),

                // profile stats
                ProfileStats(
                  postCount: postCount,
                  followerCount: user.followers.length,
                  followingCount: user.following.length,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FollowerPage(
                                followers: user.followers,
                                following: user.following,
                              ),
                        ),
                      ),
                ),
                const SizedBox(height: 25),

                // Follow Button
                if (!isOwnProfile)
                  FollowButton(
                    onPressed: followButtonPressed,
                    isFollowing: user.followers.contains(_currentUser?.uid),
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

                // list of posts from the user
                BlocBuilder<PostCubit, PostStates>(
                  builder: (context, state) {
                    if (state is PostsLoaded) {
                      // filter posts by user id
                      final userPosts =
                          state.posts
                              .where((post) => post.userId == widget.uid)
                              .toList();

                      postCount = userPosts.length;

                      return ListView.builder(
                        itemCount: postCount,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // get individual posts
                          final post = userPosts[index];

                          // return as post tile ui
                          return PostTile(
                            post: post,
                            onDeletePressed:
                                () => context.read<PostCubit>().deletePost(
                                  post.id,
                                ),
                          );
                        },
                      );
                    } else if (state is PostsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Center(child: Text('No posts found...'));
                    }
                  },
                ),
              ],
            ),
          );
        }
        // loading
        else if (state is ProfileLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
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
