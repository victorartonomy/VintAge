import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/posts/presentation/components/post_tile.dart';
import '../../../posts/presentation/cubits/post_cubits.dart';
import '../../../posts/presentation/cubits/post_states.dart';
import '../../../posts/presentation/pages/upload_post_page.dart';
import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        // title
        centerTitle: true,
        title: const Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPostPage(),
                  ),
                ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // Drawer
      drawer: MyDrawer(),

      // BODY
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
                return PostTile(post: post, onDeletePressed: () => deletePost(post.id));
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
