import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/profile/domain/entities/profile_user.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:vintage/features/services/domain/entities/service.dart';

import '../components/custom_button.dart';
import '../components/rating_widget.dart';
import '../cubits/service_cubit.dart';

class SingleServicePage extends StatefulWidget {
  final Service service;
  const SingleServicePage({super.key, required this.service});

  @override
  State<SingleServicePage> createState() => _SingleServicePageState();
}

class _SingleServicePageState extends State<SingleServicePage> {
  // service cubit
  late final serviceCubit = context.read<ServiceCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnService = false;

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  // on Startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnService = (widget.service.userId == currentUser!.uid);
  }

  // delete service
  void onDeletePressed() {
    serviceCubit.deleteService(widget.service.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.service.title),
        centerTitle: true,
        // leading: Icon(Icons.arrow_back_ios),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          // delete
          if (isOwnService)
            CustomButton(
              text: "Delete",
              icon: Icons.delete,
              onTap: onDeletePressed,
              backgroundColor: Colors.red,
              foregroundColor: Theme.of(context).colorScheme.secondary,
            ),
        ],
        actionsPadding: EdgeInsets.only(right: 10),
      ),
      extendBodyBehindAppBar: true,

      body: SingleChildScrollView(
        child: Column(
          children: [
            // image
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.service.imagesUrl[0]),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),

            // title
            SizedBox(height: 20),
            Text(
              widget.service.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),

            // subtitle
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.service.userName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 20),

            // address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.service.address,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ratings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    "Ratings: ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  RatingWidget(
                    service: widget.service,
                    showRatingDialog: true,
                    size: 25.0,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),

            // description
            SizedBox(height: 20),
            Text(
              "Description",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.service.description,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),

            // divider
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            SizedBox(height: 10),

            // services
            Text(
              "Services",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // services list
            SizedBox(
              height: 45,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.service.lstServices.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        widget.service.lstServices[index],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            SizedBox(height: 10),

            // Contact
            Text(
              "Contact",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // phone no
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(
                    IconoirIcons.phone,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.service.contactNumber,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // email
            if (widget.service.contactEmail.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(
                      IconoirIcons.mail,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.service.contactEmail,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),

            // website
            if (widget.service.website.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(
                      IconoirIcons.webWindow,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.service.website,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.service.website.isNotEmpty) SizedBox(height: 10),

            // timing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(
                    IconoirIcons.timer,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.service.timing,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // book now
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomButton(
                text: "Call Now",
                icon: IconoirIcons.phone,
                onTap: () {},
                backgroundColor: Colors.redAccent,
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
