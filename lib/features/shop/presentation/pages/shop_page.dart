import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/services/presentation/components/custom_button.dart';
import 'package:vintage/features/shop/presentation/components/product_tile.dart';
import 'package:vintage/features/shop/presentation/cubits/product_states.dart';
import 'package:vintage/features/shop/presentation/pages/upload_product_page.dart';

import '../../../authentication/domain/entities/app_user.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../cubits/product_cubit.dart';

class ShopPage extends StatefulWidget {
  final VoidCallback openDrawer;
  const ShopPage({super.key, required this.openDrawer});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // cubits
  late final productCubit = context.read<ProductCubit>();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    // fetch all services
    fetchAllProducts();

    // get current user
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  void fetchAllProducts() {
    productCubit.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: widget.openDrawer,
          icon: const Icon(IconoirIcons.menuScale),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconoirIcons.shop, color: Theme.of(context).colorScheme.primary, size: 30),
            const SizedBox(width: 10),
            const Text('Shop'),
          ],
        ),
        actions: [
          CustomButton(
            icon: IconoirIcons.upload,
            text: "Upload",
            backgroundColor: Colors.green[400],
            foregroundColor: Theme.of(context).colorScheme.secondary,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadProductPage()));
            }
          ),
        ],

        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: BlocBuilder<ProductCubit, ProductStates>(
          builder: (context, state) {

            // loading
            if (state is ProductLoading || state is ProductUploading) {
              return const Center(child: CircularProgressIndicator());
            }

            // loaded
            else if (state is ProductLoaded) {
              final allProducts = state.product;
              final likedProducts = allProducts
                  .where(
                      (product) => product.likes.contains(currentUser?.uid),
              )
                  .toList();

              if (allProducts.isEmpty) {
                return const Center(
                    child: Text("No products available...")
                );
              }

              return RefreshIndicator(
                onRefresh: () {
                  fetchAllProducts();
                  return Future.value();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[

                        // Liked Products
                        Row(
                          children: [
                            Text("Liked products", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20)),
                            const Spacer(),
                            Text("View all", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15)),
                            const SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary, size: 15),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: likedProducts.length,
                            itemBuilder: (context, index) {
                              return ProductTile(product: likedProducts[index]);
                            },
                        ),

                        // Top Rated Products
                        Row(
                          children: [
                            Text("Top rated products", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20)),
                            const Spacer(),
                            Text("View all", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15)),
                            const SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary, size: 15),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Get top rated services (services with ratings > 0, sorted by average rating)
                        Builder(
                          builder: (context) {
                            final topRatedProduct =
                            allProducts
                                .where((service) => service.averageRating > 0)
                                .toList()
                              ..sort(
                                    (a, b) =>
                                    b.averageRating.compareTo(a.averageRating),
                              );

                            if (topRatedProduct.isEmpty) {
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
                              topRatedProduct.length > 3
                                  ? 3
                                  : topRatedProduct.length,
                              itemBuilder: (context, index) {
                                return ProductTile(
                                  product: topRatedProduct[index],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // All Products
                        Row(
                          children: [
                            Text("All products", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20)),
                            const Spacer(),
                            Text("View all", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15)),
                            const SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary, size: 15),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allProducts.length,
                          itemBuilder: (context, index) {
                            return ProductTile(product: allProducts[index]);
                          },
                        )

                      ],
                    ),
                  ),
                ),
              );
            }

            // error
            else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("Loading..."));
            }

          }
      )
    );
  }
}
