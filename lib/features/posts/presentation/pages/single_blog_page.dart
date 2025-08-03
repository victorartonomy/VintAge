import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/posts/presentation/components/comment_tile.dart';
import 'package:vintage/features/services/presentation/components/custom_button.dart';

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

  void toggleLike() {
    // current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // optimistically like and update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // unlike
      } else {
        widget.post.likes.add(currentUser!.uid); // like
      }
    });

    // update like
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((
      error,
    ) {
      // if error, undo like
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // revert unlike
        } else {
          widget.post.likes.remove(currentUser!.uid); // revert like
        }
      });
    });
  }

  // delete post
  void deletePost(String postId) {
    postCubit.deletePost(postId);
    Navigator.pop(context);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,

      // appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading: Icon(Icons.menu),
        centerTitle: true,
        title: Text("Blog Details"),
        elevation: 0,
        foregroundColor: Colors.white70,
        actions: [
          if (isOwnPost)
            CustomButton(
              icon: IconoirIcons.trash,
              text: "Delete",
              backgroundColor: Colors.red[400],
              foregroundColor: Theme.of(context).colorScheme.secondary,
              onTap: () => deletePost(widget.post.id),
            ),
        ],
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
                    image: CachedNetworkImageProvider(widget.post.imageUrl),
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
                    color: Theme.of(context).colorScheme.primary,
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
                  GestureDetector(
                    onTap: toggleLike,
                    child: Icon(
                      widget.post.likes.contains(currentUser!.uid)
                          ? CupertinoIcons.suit_heart_fill
                          : IconoirIcons.heart,
                      color:
                          widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.post.likes.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.post.comments.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 20),

              // Author
              GestureDetector(
                onTap:
                    () => Navigator.push(
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
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // date
              Text(
                "Date: ${formatDateTimeManually(widget.post.timestamp)}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Divider
              Divider(
                color: Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    // paragraph
                    SizedBox(height: 10),
                    Text(
                      widget.post.text,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20),

                    // divider
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                    SizedBox(height: 20),

                    // add a new comment
                    MyTextField(
                      controller: commentController,
                      hintText: "Add Comment",
                      obscureText: false,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addComment,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        "Post",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),

                    // comments
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Comments: ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
                                return CommentTile(
                                  comment: post.comments[index],
                                );
                              },
                            );
                          }
                        }

                        // Loading
                        if (state is PostsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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

String formatDateTimeManually(DateTime dateTime) {
  // Day (dd)
  String day = dateTime.day.toString().padLeft(2, '0');

  // Month (MMM) - This is the trickiest part without a package
  String month;
  switch (dateTime.month) {
    case 1:
      month = 'Jan';
      break;
    case 2:
      month = 'Feb';
      break;
    case 3:
      month = 'Mar';
      break;
    case 4:
      month = 'Apr';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'Jun';
      break;
    case 7:
      month = 'Jul';
      break;
    case 8:
      month = 'Aug';
      break;
    case 9:
      month = 'Sep';
      break;
    case 10:
      month = 'Oct';
      break;
    case 11:
      month = 'Nov';
      break;
    case 12:
      month = 'Dec';
      break;
    default:
      month = ''; // Should not happen
  }

  // Year (yyyy)
  String year = dateTime.year.toString();

  return '$day-$month-$year';
}
