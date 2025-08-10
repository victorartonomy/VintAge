import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/posts/presentation/pages/single_blog_page.dart';
import 'package:vintage/features/profile/presentation/components/user_tile.dart';
import 'package:vintage/features/search/presentation/cubits/search_states.dart';
import 'package:vintage/features/services/presentation/pages/single_service_page.dart';
import 'package:vintage/features/shop/presentation/pages/single_product_page.dart';
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
        leading: IconButton(
          onPressed: widget.openDrawer,
          icon: const Icon(Icons.menu),
        ),

        // search Text Field
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            prefixIcon: Icon(
              IconoirIcons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: IconButton(
              onPressed: () => searchController.clear(),
              icon: Icon(
                IconoirIcons.xmark,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            if (state.results.isEmpty) {
              return const Center(child: Text("No results found"));
            }

            return ListView(
              children: [
                if (state.results.users.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Users",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...state.results.users.map((user) => UserTile(user: user)),
                ],

                if (state.results.posts.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Blog Posts",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...state.results.posts.map(
                    (post) => ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.subtitle),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleBlogPage(post: post),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                if (state.results.products.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Products",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...state.results.products.map(
                    (product) => ListTile(
                      title: Text(product.title),
                      subtitle: Text("Price: \$${product.price}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    SingleProductPage(product: product),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                if (state.results.services.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Services",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...state.results.services.map(
                    (service) => ListTile(
                      title: Text(service.title),
                      subtitle: Text(service.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    SingleServicePage(service: service),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            );
          }
          // loading
          else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // error
          else if (state is SearchError) {
            return Center(child: Text(state.message));
          }

          // default
          return Center(
            child: Text(
              "Click on the top search bar to start searching...",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
