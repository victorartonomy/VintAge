import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/shop/domain/entities/product.dart';
import 'package:vintage/features/shop/presentation/components/rating_widget_product.dart';
import 'package:vintage/features/shop/presentation/cubits/product_cubit.dart';
import 'package:vintage/features/shop/presentation/pages/single_product_page.dart';

import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/presentation/cubits/profile_cubit.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  // cubits
  late final productCubit = context.read<ProductCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnProduct = false;

  // current user
  AppUser? currentUser;

  // product user
  ProfileUser? productUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchProductUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnProduct = (widget.product.userId == currentUser!.uid);
  }

  Future<void> fetchProductUser() async {
    final fetchedUser = await profileCubit.getUserProfile(
      widget.product.userId,
    );
    if (fetchedUser != null) {
      setState(() {
        productUser = fetchedUser;
      });
    }
  }

  /*

  Likes

   */

  // user tapped like button
  void toggleLike() {
    // current like status
    final isLiked = widget.product.likes.contains(currentUser!.uid);

    // optimistically like and update UI
    setState(() {
      if (isLiked) {
        widget.product.likes.remove(currentUser!.uid);
      } else {
        widget.product.likes.add(currentUser!.uid);
      }
    });

    // update like
    productCubit.toggleLike(widget.product.id, currentUser!.uid).catchError((
      error,
    ) {
      // if error undo like
      setState(() {
        if (isLiked) {
          widget.product.likes.add(currentUser!.uid);
        } else {
          widget.product.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleProductPage(product: widget.product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // images
                CachedNetworkImage(
                  imageUrl: widget.product.imagesUrl[0],
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
                        Colors.red.withAlpha(200),
                        Colors.transparent.withAlpha(50),
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
                              widget.product.likes.contains(currentUser!.uid)
                                  ? CupertinoIcons.heart_fill
                                  : IconoirIcons.heart,
                              color:
                                  widget.product.likes.contains(
                                        currentUser!.uid,
                                      )
                                      ? Colors.red
                                      : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.product.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Rating widget
                      RatingWidgetProduct(
                        product: widget.product,
                        size: 16.0,
                        color: Colors.amber,
                      ),

                      // description
                      Expanded(
                        child: Text(
                          widget.product.description,
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // price
                      Text(
                        "₹${widget.product.price}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
