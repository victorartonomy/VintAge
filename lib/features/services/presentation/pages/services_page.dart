import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_states.dart';
import 'package:vintage/features/services/presentation/components/custom_button.dart';
import 'package:vintage/features/services/presentation/components/service_tile.dart';
import 'package:vintage/features/services/presentation/pages/upload_service_page.dart';
import 'package:vintage/responsive/constrained_scaffold.dart';

import '../cubits/service_cubit.dart';
import '../cubits/service_states.dart';

class ServicesPage extends StatefulWidget {
  final VoidCallback openDrawer;
  final String uid;
  const ServicesPage({super.key, required this.openDrawer, required this.uid});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  // Controllers
  late final favServiceController = PageController(initialPage: 0);
  late final topRatedServiceController = PageController(initialPage: 0);

  // cubits
  late final serviceCubit = context.read<ServiceCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    // fetch all services
    fetchAllServices();

    // get current user
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;

    // load user profile
    profileCubit.fetchUserProfile(widget.uid);
  }

  void fetchAllServices() {
    serviceCubit.fetchAllServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;

          return ConstrainedScaffold(
            backgroundColor: Theme.of(context).colorScheme.secondary,

            // app bar
            appBar: AppBar(
              leading: IconButton(
                onPressed: widget.openDrawer,
                icon: const Icon(IconoirIcons.menuScale),
              ),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(IconoirIcons.suitcase),
                  SizedBox(width: 8),
                  Text("Services"),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                if (user.isAuthor)
                  CustomButton(
                    icon: IconoirIcons.upload,
                    text: "Upload",
                    backgroundColor: Colors.green[400],
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadServicePage(),
                          ),
                        ),
                  ),
              ],
              actionsPadding: const EdgeInsets.only(right: 20),
            ),

            // body
            body: BlocBuilder<ServiceCubit, ServiceStates>(
              builder: (context, state) {
                // loading
                if (state is ServicesLoading || state is ServicesUploading) {
                  return const Center(child: CircularProgressIndicator());
                }
                // loaded
                else if (state is ServicesLoaded) {
                  final allServices = state.services;
                  final likedServices =
                      allServices
                          .where(
                            (service) =>
                                service.likes.contains(currentUser?.uid),
                          )
                          .toList();

                  if (allServices.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconoirIcons.suitcase, size: 100),
                          SizedBox(height: 20),
                          Text("No services available..."),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      fetchAllServices();
                      return Future.value();
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          // Favourites
                          Row(
                            children: [
                              Text(
                                "Favourites",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          SizedBox(
                            height: 300,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: likedServices.length,
                              controller: favServiceController,
                              itemBuilder: (context, index) {
                                // Services builder
                                if (likedServices.isNotEmpty) {
                                  return ServiceTile(
                                    service: likedServices[index],
                                  );
                                } else {
                                  return const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(IconoirIcons.suitcase, size: 100),
                                        SizedBox(height: 20),
                                        Text(
                                          "Click on the heart icon to like a service...",
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          SmoothPageIndicator(
                            controller: favServiceController,
                            count: likedServices.length,
                            effect: ExpandingDotsEffect(
                              activeDotColor: Color.fromARGB(255, 255, 90, 90),
                              dotColor: Theme.of(context).colorScheme.primary,
                              dotHeight: 10,
                              dotWidth: 10,
                            ),
                          ),

                          // Top Rated Services
                          Row(
                            children: [
                              Text(
                                "Top Rated",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Get top rated services (services with ratings > 0, sorted by average rating)
                          Builder(
                            builder: (context) {
                              final topRatedServices =
                                  allServices
                                      .where(
                                        (service) => service.averageRating > 0,
                                      )
                                      .toList()
                                    ..sort(
                                      (a, b) => b.averageRating.compareTo(
                                        a.averageRating,
                                      ),
                                    );

                              if (topRatedServices.isEmpty) {
                                return SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      "No rated services yet",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topRatedServices.length,
                                      controller: topRatedServiceController,
                                      itemBuilder: (context, index) {
                                        // blog
                                        return ServiceTile(
                                          service: topRatedServices[index],
                                        );
                                      },
                                    ),
                                  ),
                                  SmoothPageIndicator(
                                    controller: topRatedServiceController,
                                    count: topRatedServices.length,
                                    effect: ExpandingDotsEffect(
                                      activeDotColor: Color.fromARGB(
                                        255,
                                        255,
                                        90,
                                        90,
                                      ),
                                      dotColor:
                                          Theme.of(context).colorScheme.primary,
                                      dotHeight: 10,
                                      dotWidth: 10,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          // All Services
                          Row(
                            children: [
                              Text(
                                "All Services",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allServices.length,
                            itemBuilder: (context, index) {
                              final service = allServices[index];
                              return ServiceTile(service: service);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // error
                else if (state is ServicesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("Loading..."));
                }
              },
            ),
          );
        } else if (state is ProfileLoading) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No profile found...')),
          );
        }
      },
    );
  }
}
