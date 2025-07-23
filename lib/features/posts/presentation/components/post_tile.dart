import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/presentation/components/my_text_field.dart';
import 'package:vintage/features/posts/domain/entities/comment.dart';
import 'package:vintage/features/posts/domain/entities/post.dart';
import 'package:vintage/features/posts/presentation/components/comment_tile.dart';
import 'package:vintage/features/posts/presentation/cubits/post_cubits.dart';
import 'package:vintage/features/posts/presentation/cubits/post_states.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:vintage/features/profile/presentation/pages/profile_page.dart';

import '../../../authentication/presentation/cubits/auth_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  // on Startup
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

  /*

  Likes

   */

  // user tapped like button
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

  /*

  Comments

   */

  // comment text controller
  final commentTextController = TextEditingController();

  // open comment box -> user wants to type a new comment
  void openCommentBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add a new comment"),

            content: MyTextField(
              controller: commentTextController,
              hintText: "Your thoughts",
              obscureText: false,
            ),

            actions: [
              // cancel
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),

              // Save
              TextButton(
                onPressed: () {
                  addComment();
                  Navigator.of(context).pop();
                },
                child: Text("Save"),
              ),
            ],
          ),
    );
  }

  void addComment() {
    // create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  // show options for deleting
  void showOptions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: Text(
              "Delete Post?",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            content: Text(
              "Are you sure you want to delete this post?",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            actions: [
              // cancel
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              // delete
              TextButton(
                onPressed: () {
                  widget.onDeletePressed!();
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // top section: profile pic / name / delete button
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // profile pic
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget:
                            (context, url, error) => const Icon(Icons.person),
                        imageBuilder:
                            (context, imageProvider) => Container(
                              width: 40,
                              height: 40,
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
                  const SizedBox(width: 20),

                  // name
                  Text(
                    widget.post.userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const Spacer(),

                  // delete
                  if (isOwnPost)
                    IconButton(
                      onPressed: showOptions,
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // like, comment, timestamp
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Like
                GestureDetector(
                  onTap: toggleLike,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? CupertinoIcons.suit_heart_fill
                        : IconoirIcons.heart,
                    color:
                        widget.post.likes.contains(currentUser!.uid)
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                // count
                Text(
                  widget.post.likes.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 20),

                // comment
                IconButton(
                  onPressed: openCommentBox,
                  icon: Icon(
                    IconoirIcons.message,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),

                // timestamp
                Text(formatDateTimeManually(widget.post.timestamp)),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Row(
              children: [
                // username
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),

                // text
                Text(widget.post.text),
              ],
            ),
          ),

          // Comments
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: showCommentCount,
                    itemBuilder: (context, index) {
                      // get individual comments
                      final comment = post.comments[index];

                      // comment tile ui
                      return CommentTile(comment: comment);
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
                return const SizedBox();
              }
            },
          ),
        ],
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

  return '$day/$month/$year';
}
