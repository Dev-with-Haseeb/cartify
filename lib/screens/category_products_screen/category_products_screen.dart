import 'package:cartify/providers/product_provider.dart';
import 'package:cartify/widgets/products_grid.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class CategoryProductsScreen extends StatelessWidget {
  final String categoryId;

  const CategoryProductsScreen({super.key, required this.categoryId});

  Future<String> getCategoryName(String categoryId) async {
    final categorySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .get();

    if (categorySnapshot.exists) {
      return categorySnapshot.data()?['name'] ?? 'Category';
    }
    return 'Category';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        title: FutureBuilder<String>(
          future: getCategoryName(categoryId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return Text(
                snapshot.data ?? 'Category',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            // Filter products by categoryId
            final categoryProducts = productProvider.products
                .where((product) => product.categoryId == categoryId)
                .toList();

            if (categoryProducts.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            return SingleChildScrollView(
              child: ProductsGrid(products: categoryProducts),
            );
          },
        ),
      ),
    );
  }
}