import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/services/presentation/components/service_tile.dart';
import 'package:vintage/features/services/presentation/pages/upload_service_page.dart';

import '../cubits/service_cubit.dart';
import '../cubits/service_states.dart';

class ServicesPage extends StatefulWidget {
  final VoidCallback openDrawer;
  const ServicesPage({super.key, required this.openDrawer});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  // cubits
  late final serviceCubit = context.read<ServiceCubit>();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    // fetch all services
    fetchAllServices();

    // get current user
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  void fetchAllServices() {
    serviceCubit.fetchAllServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      // app bar
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.openDrawer,
          icon: const Icon(IconoirIcons.menuScale),
        ),
        title: const Text("Services"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadServicePage(),
                  ),
                ),
            icon: const Icon(IconoirIcons.plus),
          ),
        ],
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
                      (service) => service.likes.contains(currentUser?.uid),
                    )
                    .toList();

            if (allServices.isEmpty) {
              return const Center(child: Text("No services available"));
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
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: likedServices.length,
                      itemBuilder: (context, index) {
                        return ServiceTile(service: likedServices[index]);
                      },
                    ),
                    const SizedBox(height: 20),

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
                    const SizedBox(height: 20),
                    // Get top rated services (services with ratings > 0, sorted by average rating)
                    Builder(
                      builder: (context) {
                        final topRatedServices =
                            allServices
                                .where((service) => service.averageRating > 0)
                                .toList()
                              ..sort(
                                (a, b) =>
                                    b.averageRating.compareTo(a.averageRating),
                              );

                        if (topRatedServices.isEmpty) {
                          return SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                "No rated services yet",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              topRatedServices.length > 3
                                  ? 3
                                  : topRatedServices.length,
                          itemBuilder: (context, index) {
                            return ServiceTile(
                              service: topRatedServices[index],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),

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
                    const SizedBox(height: 20),
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
  }
}
