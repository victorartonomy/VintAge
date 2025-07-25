import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/posts/domain/entities/comment.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../cubits/post_cubits.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  // current user
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  // get First name
  String getFirstName(String fullName) {
    if (fullName.isEmpty) return '';

    // Split the name by whitespace
    List<String> parts = fullName.trim().split(' ');

    // Return the first part as first name
    return parts[0];
  }

  void showOptions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            title: const Text("Delete Comment?"),
            content: const Text("Are you sure you want to delete this post?"),
            actions: [
              // cancel
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              // delete
              TextButton(
                onPressed: () {
                  context.read<PostCubit>().deleteComment(
                    widget.comment.postId,
                    widget.comment.id,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // profile pic
            // Container(
            //   height: 30,
            //   width: 30,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     image: DecorationImage(
            //       image: AssetImage("assets/images/img1.jpg"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),

            // author name
            SizedBox(width: 10),
            Text(
              '${getFirstName(widget.comment.userName)} :',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),

            // comment text
            SizedBox(width: 10),
            Flexible(
              child: Expanded(
                child: Text(
                  widget.comment.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),

            // delete
            if (isOwnPost)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: showOptions,
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
