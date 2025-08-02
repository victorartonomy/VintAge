import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/services/domain/entities/service.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../../profile/presentation/cubits/profile_cubit.dart';
import '../cubits/service_cubit.dart';
import '../pages/single_service_page.dart';
import 'rating_widget.dart';

class ServiceTile extends StatefulWidget {
  final Service service;
  const ServiceTile({super.key, required this.service});

  @override
  State<ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  // cubits
  late final serviceCubit = context.read<ServiceCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnService = false;

  // current user
  AppUser? currentUser;

  // service user
  ProfileUser? serviceUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchServiceUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnService = (widget.service.userId == currentUser!.uid);
  }

  Future<void> fetchServiceUser() async {
    final fetchedUser = await profileCubit.getUserProfile(
      widget.service.userId,
    );
    if (fetchedUser != null) {
      setState(() {
        serviceUser = fetchedUser;
      });
    }
  }

  /*

  Likes

   */

  // user tapped like button
  void toggleLike() {
    // current like status
    final isLiked = widget.service.likes.contains(currentUser!.uid);

    // optimistically like and update UI
    setState(() {
      if (isLiked) {
        widget.service.likes.remove(currentUser!.uid);
      } else {
        widget.service.likes.add(currentUser!.uid);
      }
    });

    // update like
    serviceCubit.toggleLike(widget.service.id, currentUser!.uid).catchError((
      error,
    ) {
      // if error undo like
      setState(() {
        if (isLiked) {
          widget.service.likes.add(currentUser!.uid);
        } else {
          widget.service.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleServicePage(service: widget.service),
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 300,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // images
                CachedNetworkImage(
                  imageUrl: widget.service.imagesUrl[0],
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

                // Text info
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: toggleLike,
                            icon: Icon(
                              widget.service.likes.contains(currentUser!.uid)
                                  ? CupertinoIcons.heart_fill
                                  : IconoirIcons.heart,
                              color:
                                  widget.service.likes.contains(
                                        currentUser!.uid,
                                      )
                                      ? Colors.red
                                      : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        widget.service.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.service.lstServices.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 5, right: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.service.lstServices[index],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Rating widget
                      RatingWidget(
                        service: widget.service,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          widget.service.description,
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
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
