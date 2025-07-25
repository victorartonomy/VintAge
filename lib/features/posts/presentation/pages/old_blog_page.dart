import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/posts/presentation/pages/old_upload_post_page.dart';

import '../components/post_tile.dart';
import '../cubits/post_cubits.dart';
import '../cubits/post_states.dart';

class OldBlogPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const OldBlogPage({super.key, required this.openDrawer});

  @override
  State<OldBlogPage> createState() => _OldBlogPageState();
}

class _OldBlogPageState extends State<OldBlogPage> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  // on startup (initial state)
  @override
  void initState() {
    super.initState();

    // fetch all posts
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      // App Bar
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: const Text("Blog"),
        leading: IconButton(
          onPressed: widget.openDrawer,
          icon: const Icon(IconoirIcons.menuScale),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OldUploadPostPage(),
                  ),
                ),
            icon: Icon(IconoirIcons.upload),
          ),
        ],
      ),

      // Body
      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          // loading
          if (state is PostsLoading && state is PostsUploading) {
            return const Center(child: CircularProgressIndicator());
          }
          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(child: Text("No posts available"));
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {

                // get individual post
                final post = allPosts[index];

                // image
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }
          // error
          else if (state is PostsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
