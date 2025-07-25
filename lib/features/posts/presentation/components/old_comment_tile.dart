import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/posts/domain/entities/comment.dart';
import 'package:vintage/features/posts/presentation/cubits/post_cubits.dart';

import '../../../authentication/presentation/cubits/auth_cubit.dart';

class OldCommentTile extends StatefulWidget {
  final Comment comment;
  const OldCommentTile({super.key, required this.comment});

  @override
  State<OldCommentTile> createState() => _OldCommentTileState();
}

class _OldCommentTileState extends State<OldCommentTile> {
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

  void showOptions() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // name
          Text(
            widget.comment.userName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),

          // comment text
          Text(widget.comment.text),
          const Spacer(),

          // delete button
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
    );
  }
}
