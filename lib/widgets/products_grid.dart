import 'package:cartify/models/product_model.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/screens/product_detail_screen/product_detail_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key, required this.products, this.itemCount});

  final List<Product> products;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount ?? products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        childAspectRatio: 0.7, // Adjust height of items if needed
        crossAxisSpacing: 8, // Spacing between columns
        mainAxisSpacing: 8, // Spacing between rows
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ProductDetailScreen(product: product),
          withNavBar: false, // Hides the bottom navigation bar
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Card(
        color: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.robotoCondensed(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Stock: ',
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.grey, fontSize: 8),
                  ),
                  Text(
                    product.instock ? 'In Stock' : 'Out of Stock',
                    style: GoogleFonts.robotoCondensed(
                        color: product.instock ? Colors.green : Colors.red,
                        fontSize: 9),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox(height: double.infinity)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 16,
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (product.instock) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addItem(product.id, product.price, product.name);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!', style: const TextStyle(color: Colors.white)),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }else{
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} is Out of Stock!', style: const TextStyle(color: Colors.white)),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: product.instock
                          ? const Color.fromARGB(255, 0, 128, 128)
                          : const Color.fromARGB(90, 0, 128, 128),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: const SizedBox(
                        height: 36,
                        width: 36,
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
