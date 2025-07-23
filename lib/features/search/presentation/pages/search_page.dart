import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/profile/presentation/components/user_tile.dart';
import 'package:vintage/features/search/presentation/cubits/search_states.dart';
import 'package:vintage/responsive/constrained_scaffold.dart';

import '../cubits/search_cubit.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback openDrawer;
  const SearchPage({super.key, required this.openDrawer});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controllers
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();

    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build UI
    return ConstrainedScaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,

      // AppBar
      appBar: AppBar(
        leading: IconButton(onPressed: widget.openDrawer, icon: const Icon(Icons.menu)),
        // search Text Field
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            prefixIcon: Icon(IconoirIcons.search, color: Theme.of(context).colorScheme.primary),
            suffixIcon: IconButton(
              onPressed: () => searchController.clear(),
              icon: Icon(IconoirIcons.xmark, color: Theme.of(context).colorScheme.primary),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no user
            if (state.users.isEmpty) {
              return const Center(child: Text("No users found"),);
            }

            // users
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              },
            );
          }

          // loading
          else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // error
          else if (state is SearchError) {
            return Center(child: Text(state.message),);
          }

          // default
          return const Center(child: Text("Start Searching for user"),);
        },
      ),
    );
  }
}
