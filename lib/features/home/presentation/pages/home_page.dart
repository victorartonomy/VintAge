import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/home/presentation/components/drawer_item.dart';
import 'package:vintage/features/home/presentation/components/hidden_drawer.dart';
import 'package:vintage/features/posts/presentation/pages/blog_page.dart';
import 'package:vintage/features/profile/presentation/pages/profile_page.dart';
import 'package:vintage/features/search/presentation/pages/search_page.dart';
import 'package:vintage/features/services/presentation/pages/services_page.dart';
import 'package:vintage/features/settings/presentation/pages/settings_page.dart';
import 'package:vintage/features/shop/presentation/pages/shop_page.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../components/drawer_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  DrawerItem item = DrawerItems.blog;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    isDrawerOpen = false;
    xOffset = 0;
    yOffset = 0;
    scaleFactor = 1;
    item = DrawerItems.blog;
    isDragging = false;
  }

  void closeDrawer() {
    if (!isDrawerOpen) return;
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  void openDrawer() {
    if (isDrawerOpen) return;
    setState(() {
      xOffset = 190;
      yOffset = 150;
      scaleFactor = 0.7;
      isDrawerOpen = true;
    });
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;
    if (user == null) return const SizedBox(); // or a loading/error widget
    String uid = user.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // BODY
      body: Stack(
        children: [
          HiddenDrawer(
            onSelectedItemChanged: (item) {
              setState(() => this.item = item);
              closeDrawer();
            },
            selectedItem: item,
          ),
          // WillPopScope(
            // onWillPop: () async {
            //   if (isDrawerOpen) {
            //     closeDrawer();
            //     return false;
            //   } else {
            //     return true;
            //   }
            // },
          PopScope<Object?>(
            canPop: !isDrawerOpen,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (didPop) {
                return;
              }
              if (isDrawerOpen) {
                closeDrawer();
              }
            },
            child: GestureDetector(
              onTap: closeDrawer,
              onHorizontalDragStart: (details) => isDragging = true,
              onHorizontalDragUpdate: (details) {
                if (!isDragging) return;

                const delta = 1;
                if (details.delta.dx > delta) {
                  openDrawer();
                } else if (details.delta.dx < -delta) {
                  closeDrawer();
                }
              },
              onHorizontalDragEnd: (details) {
                isDragging = false;
              },

              child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      offset: Offset(0, 0),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFactor),
                child: AbsorbPointer(
                  absorbing: isDrawerOpen,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      //color: isDrawerOpen? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.surface,
                      child: getDrawerPage(uid),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDrawerPage(String uid) {
    switch (item) {
      case DrawerItems.blog:
        return BlogPage(openDrawer: openDrawer);
      case DrawerItems.services:
        return ServicesPage(openDrawer: openDrawer);
      case DrawerItems.profile:
        return ProfilePage(uid: uid, openDrawer: openDrawer);
      case DrawerItems.search:
        return SearchPage(openDrawer: openDrawer);
      case DrawerItems.shop:
        return ShopPage(openDrawer: openDrawer);
      case DrawerItems.setting:
        return SettingsPage(openDrawer: openDrawer);
      case DrawerItems.logout:
        return logout();
      default:
        return BlogPage(openDrawer: openDrawer);
    }
  }

  Widget logout() {
    return AlertDialog(
      title: const Text('Logout'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            context.read<AuthCubit>().logout();
          },
          child: Text('Logout'),
        ),
        TextButton(onPressed: () {}, child: Text('Cancel')),
      ],
    );
  }
}
