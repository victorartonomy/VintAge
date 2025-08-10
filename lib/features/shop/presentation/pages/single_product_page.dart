import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:vintage/features/authentication/domain/entities/app_user.dart';
import 'package:vintage/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:vintage/features/shop/presentation/components/rating_widget_product.dart';
import '../../../authentication/presentation/cubits/auth_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../services/presentation/components/custom_button.dart';
import '../../domain/entities/product.dart';
import '../cubits/product_cubit.dart';
import 'image_viewer_page.dart';

class SingleProductPage extends StatefulWidget {
  final Product product;
  const SingleProductPage({super.key, required this.product});

  @override
  State<SingleProductPage> createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  // product cubit
  late final productCubit = context.read<ProductCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnProduct = false;

  // current user
  AppUser? currentUser;

  // product user
  ProfileUser? productUser;

  // on Startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnProduct = (widget.product.userId == currentUser!.uid);
  }

  // delete product
  void onDeletePressed() {
    productCubit.deleteProduct(widget.product.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.product.title),
        centerTitle: true,
        // leading: Icon(Icons.arrow_back_ios),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          // delete
          if (isOwnProduct)
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
            // Main image
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ImageViewerPage(
                            images: widget.product.imagesUrl,
                            initialIndex: 0,
                          ),
                    ),
                  ),
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.product.imagesUrl[0]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),
            ),

            // Gallery Section
            if (widget.product.imagesUrl.length > 1) ...[
              const SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Text(
              //     "Gallery",
              //     style: TextStyle(
              //       color: Theme.of(context).colorScheme.primary,
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.product.imagesUrl.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ImageViewerPage(
                                    images: widget.product.imagesUrl,
                                    initialIndex: index,
                                  ),
                            ),
                          ),
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.product.imagesUrl[index],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // title
            SizedBox(height: 20),
            Text(
              widget.product.title,
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
                widget.product.userName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 20),

            // price
            Text(
              "Price: ₹${widget.product.price}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.product.address,
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
                  RatingWidgetProduct(
                    product: widget.product,
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
                widget.product.description,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
                    widget.product.contactNumber,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // email
            if (widget.product.contactEmail.isNotEmpty)
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
                      widget.product.contactEmail,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
