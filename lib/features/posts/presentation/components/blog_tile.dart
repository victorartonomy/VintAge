import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/posts/presentation/cubits/post_cubits.dart';
import 'package:vintage/features/posts/presentation/pages/single_blog_page.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/presentation/cubits/profile_cubit.dart';
import '../../domain/entities/post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlogTile extends StatefulWidget {
  final Post post;
  const BlogTile({
    super.key,
    required this.post,
  });

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
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

  // get First name
  String getFirstName(String fullName) {
    if (fullName.isEmpty) return '';

    // Split the name by whitespace
    List<String> parts = fullName.trim().split(' ');

    // Return the first part as first name
    return parts[0];
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleBlogPage(post: widget.post),
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.post.imageUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Center(child: Icon(Icons.error)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.red.withOpacity(.6),
                        Colors.transparent.withOpacity(.2),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // favorite icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                      : Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title
                          Text(
                            widget.post.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),

                          // author
                          Text(
                            "By: ${getFirstName(widget.post.userName)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          // date
                          Text(
                            formatDateTimeManually(widget.post.timestamp),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
