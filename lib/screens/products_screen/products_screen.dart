import 'package:cartify/providers/product_provider.dart';
import 'package:cartify/screens/cart_screen/cart_screen.dart';
import 'package:cartify/widgets/products_grid.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        title: Text(
          'Products',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const CartScreen(),
                withNavBar: false, // Hides the bottom navigation bar
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            icon: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              );
            }

            // Use the products from ProductProvider
            final products = productProvider.products;

            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            return SingleChildScrollView(
              child: ProductsGrid(products: products),
            );
          },
        ),
      ),
    );
  }
}