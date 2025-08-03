import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vintage/features/posts/presentation/components/blog_tile.dart';
import 'package:vintage/features/posts/presentation/pages/upload_blog_page.dart';
import 'package:vintage/features/services/presentation/components/custom_button.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../cubits/post_cubits.dart';
import '../cubits/post_states.dart';

class BlogPage extends StatefulWidget {
  final VoidCallback openDrawer;
  const BlogPage({super.key, required this.openDrawer});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  AppUser? currentUser;

  // on startup (initial state)
  @override
  void initState() {
    super.initState();

    // fetch all posts
    fetchAllPosts();

    // get current user
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // fetch all posts
  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    final blogController = PageController(initialPage: 0);

    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,

      // appbar
      appBar: AppBar(
        leading: IconButton(onPressed: widget.openDrawer, icon: const Icon(IconoirIcons.menuScale)),
        title: const Text("Blog"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          CustomButton(
            icon: IconoirIcons.upload,
            text: "Upload",
            backgroundColor: Colors.green[400],
            foregroundColor: Theme.of(context).colorScheme.secondary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadBlogPage(),
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 20),
      ),

      // body
      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          // loading
          if (state is PostsLoading && state is PostsUploading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;
            final likedPosts = allPosts.where((post) => post.likes.contains(currentUser?.uid)).toList();

            if (allPosts.isEmpty) {
              return const Center(child: Text("No posts available"));
            }

            return RefreshIndicator(
              onRefresh: () {
                fetchAllPosts();
                return Future.value();
                },
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[

                    // Recent Blogs
                    Row(
                      children: [
                        Text(
                          "Recent Blogs",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "View All",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Most recent Blogs
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        controller: blogController,
                        itemBuilder: (context, index) {
                          // get final blog
                          final post = allPosts.take(4).toList();

                          // blog
                          return BlogTile(post: post[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // page indicator
                    SmoothPageIndicator(
                      controller: blogController,
                      count: 4,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Color.fromARGB(255, 255, 90, 90),
                        dotColor: Theme.of(context).colorScheme.primary,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // You may/will like these
                    Row(
                      children: [
                        Text(
                          "You may like these",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        // Text(
                        //   "View All",
                        //   style: TextStyle(
                        //     color: Colors.white70,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(width: 10),
                        // Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Blogs
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: allPosts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return BlogTile(post: allPosts[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // favourite Blogs
                    Row(
                      children: [
                        Text(
                          "Your Favourite's",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        // Text(
                        //   "View All",
                        //   style: TextStyle(
                        //     color: Colors.white70,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(width: 10),
                        // Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Blogs
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: likedPosts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return BlogTile(post: likedPosts[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // all Blogs
                    Row(
                      children: [
                        Text(
                          "All Blogs",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        // Text(
                        //   "View All",
                        //   style: TextStyle(
                        //     color: Colors.white70,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(width: 10),
                        // Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 2, // Number of columns
                      //   crossAxisSpacing: 10.0,
                      //   mainAxisSpacing: 10.0,
                      //   childAspectRatio: 1.0, // Width/height ratio
                      // ),
                      shrinkWrap: true,
                      itemCount: allPosts.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BlogTile(post: allPosts[index]);
                      },
                    ),
                    const SizedBox(height: 20),

                    // The End
                    Text("The End!", style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
          // error
          else if (state is PostsError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

    );
  }
}
