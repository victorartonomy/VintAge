/*

This page will display a tab bar to show

  - list of followers
  - list of following

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/profile/presentation/components/user_tile.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_cubit.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // Tab Controller
    return DefaultTabController(
      length: 2,

      // Scaffolds
      child: Scaffold(
        // App Bar
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          // tab bar
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),

        // Tab bar View
        body: TabBarView(
          children: [
            _buildUserList(followers, "No Followers", context),
            _buildUserList(following, "No Following", context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(
    List<String> uids,
    String emptyMessage,
    BuildContext context,
  ) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
          itemCount: uids.length,
          itemBuilder: (context, index) {
            // get each uid
            final uid = uids[index];

            return FutureBuilder(
              future: context.read<ProfileCubit>().getUserProfile(uid),
              builder: (context, snapshot) {
                // user loaded
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return UserTile(user: user);
                }
                // loading...
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(title: Text("Loading..."));
                }
                // not found
                else {
                  return ListTile(title: Text("User not found"));
                }
              },
            );
          },
        );
  }
}
