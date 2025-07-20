/*

Follow Button

This is a follow / unfollow button

--------------------------------------------------------------------

To use this widget u need:
  - a function (e.g. toggleFollow)
  - isFollowing (e.g. false -> then we will show the follow button instead of unfollow)

 */

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
          padding: const EdgeInsets.all(25),
          onPressed: onPressed,
          color:
              isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          child: Text(
            isFollowing ? 'Unfollow' : 'Follow',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
