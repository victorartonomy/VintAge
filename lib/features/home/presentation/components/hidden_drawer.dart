import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/home/presentation/components/drawer_items.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../../profile/presentation/cubits/profile_cubit.dart';
import 'drawer_item.dart';

class HiddenDrawer extends StatefulWidget {
  final ValueChanged<DrawerItem> onSelectedItemChanged;
  final DrawerItem selectedItem;

  const HiddenDrawer({
    super.key,
    required this.onSelectedItemChanged,
    required this.selectedItem,
  });

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  late final profileCubit = context.read<ProfileCubit>();

  // get current user
  AppUser? currentUser;
  late Future<String?> profileImageUrlFuture;

  @override
  void initState() {
    super.initState();

    // get current user
    getCurrentUser();
    profileImageUrlFuture = Future.microtask(
      () => getProfileImageUrl(currentUser!.uid),
    );
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<String?> getProfileImageUrl(String uid) async {
    final profileUser = await profileCubit.getUserProfile(uid);
    if (profileUser == null) {
      return '';
    } else {
      return profileUser.profileImageUrl;
    }
  }

  // get First name
  String getFirstName(String fullName) {
    if (fullName.isEmpty) return '';

    // Split the name by whitespace
    List<String> parts = fullName.trim().split(' ');

    // Return the first part as first name
    return parts[0];
  }

  @override
  Widget build(BuildContext context) {
    // profile
    final user = context.read<AuthCubit>().currentUser;
    String firstName = getFirstName(user!.name);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Column(
        children: [
          GestureDetector(
            onTap: () => widget.onSelectedItemChanged(DrawerItems.profile),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 80),
              child: Row(
                children: [
                  FutureBuilder<String?>(
                    future: profileImageUrlFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        );
                      }
                      final imageUrl = snapshot.data;
                      if (imageUrl == null || imageUrl.isEmpty) {
                        return const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        );
                      }
                      return CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(imageUrl),
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Welcome, $firstName',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 150),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                buildDrawerItems(context, widget.selectedItem),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context, DrawerItem selectedItem) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            DrawerItems.all
                .map(
                  (item) => ListTile(
                    leading: Icon(
                      item.icon,
                      color:
                          item == selectedItem
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context).colorScheme.primary,
                    ),
                    title:
                        item == selectedItem
                            ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : Text(
                              item.title,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () => widget.onSelectedItemChanged(item),
                  ),
                )
                .toList(),
      );
}
