/*

Profile stats: This will be displayed on all profile pages

------------------------------------------------------------------

Number of
  - posts
  - followers
  - followings

 */

import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    var textStyleForCount = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);
    var textStyleForTitle = TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.primary);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // posts
          Column(
            children: [
              Text(postCount.toString(), style: textStyleForCount),
              Text("Posts", style: textStyleForTitle),
            ],
          ),
      
          // followers
          Column(
            children: [
              Text(followerCount.toString(), style: textStyleForCount),
              Text("Followers", style: textStyleForTitle),
            ],
          ),
      
          // followings
          Column(
            children: [
              Text(followingCount.toString(), style: textStyleForCount),
              Text("Followings", style: textStyleForTitle),
            ],
          ),
        ],
      ),
    );
  }
}
