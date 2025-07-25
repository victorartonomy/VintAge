import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/posts/presentation/components/comment_tile.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/presentation/cubits/profile_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../cubits/post_cubits.dart';
import '../cubits/post_states.dart';

class SingleBlogPage extends StatefulWidget {
  final Post post;
  const SingleBlogPage({super.key, required this.post});

  @override
  State<SingleBlogPage> createState() => _SingleBlogPageState();
}

class _SingleBlogPageState extends State<SingleBlogPage> {

  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // controller
  final commentController = TextEditingController();

  AppUser? currentUser;
  bool isOwnPost = false;

  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }


  void addComment() {
    // create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }

    commentController.clear();
  }
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 28, 28, 28),

      // appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading: Icon(Icons.menu),
        centerTitle: true,
        title: Text("Blog Details"),
        elevation: 0,
        foregroundColor: Colors.white70,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.delete))],
        surfaceTintColor: Colors.transparent,
      ),

      // Body
      body: SingleChildScrollView(
        child: Flexible(
          child: Column(
            children: [
          
              // image
              Container(
                height: 400,
                // image
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.post.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),
              SizedBox(height: 20),
          
              // Title
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  widget.post.title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
          
              // stats
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO: check if post is liked by the user?
                  Icon(Icons.favorite, color: Colors.red),
                  SizedBox(width: 10),
                  Text(widget.post.likes.length.toString(), style: TextStyle(color: Colors.white70)),
                  SizedBox(width: 20),
                  Icon(Icons.comment, color: Colors.white70),
                  SizedBox(width: 10),
                  Text(widget.post.comments.length.toString(), style: TextStyle(color: Colors.white70)),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 20),
          
              // Author
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProfilePage(
                      uid: widget.post.userId,
                      openDrawer: () => Navigator.pop(context),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    postUser?.profileImageUrl != null
                        ? CachedNetworkImage(
                      imageUrl: postUser!.profileImageUrl,
                      errorWidget:
                          (context, url, error) => const Icon(Icons.person),
                      imageBuilder:
                          (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                        : const Icon(Icons.person),
                    const SizedBox(width: 10),
                    Text(
                      "By: ${widget.post.userName}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
          
              // date
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Date: ${widget.post.timestamp}",
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
          
              // Divider
              Divider(
                color: Colors.white70,
                thickness: 1,
                indent: 30,
                endIndent: 30,
              ),
              SizedBox(height: 20),
          
              // Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // sub heading
                    Row(
                      children: [
                        Text(
                          widget.post.subtitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    // paragraph
                    SizedBox(height: 10),
                    Text(widget.post.text),
                    SizedBox(height: 20),
          
                    // divider
                    Divider(
                      color: Colors.white70,
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                    SizedBox(height: 20),
          
                    // add a new comment
                    MyTextField(controller: commentController, hintText: "Add Comment", obscureText: false),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addComment,
                      child: Text("Post"),
                    ),
          
                    // comments
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Comments: ",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    BlocBuilder<PostCubit, PostStates>(
                      builder: (context, state) {
                        // Loaded
                        if (state is PostsLoaded) {
                          // final individual post
                          final post = state.posts.firstWhere(
                                (post) => (post.id == widget.post.id),
                          );
          
                          if (post.comments.isNotEmpty) {
                            // how many comments to show
                            int showCommentCount = post.comments.length;
          
                            // comment section
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: showCommentCount,
                              itemBuilder: (context, index) {
                                return CommentTile(comment: post.comments[index]);
                              },
                            );
                          }
                        }
          
                        // Loading
                        if (state is PostsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        // Error
                        else if (state is PostsError) {
                          return Center(child: Text(state.message));
                        } else {
                          return Center(child: Text("No Comments"));
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
