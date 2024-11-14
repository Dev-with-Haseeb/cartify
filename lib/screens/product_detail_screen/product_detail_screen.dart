import 'package:cartify/models/product_model.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.product.name),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Name
              Text(
                widget.product.name,
                style: GoogleFonts.robotoCondensed(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              Row(
                children: [
                  Text(
                    'Stock: ',
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.grey, fontSize: 10),
                  ),
                  Text(
                    widget.product.instock ? 'In Stock' : 'Out of Stock',
                    style: GoogleFonts.robotoCondensed(
                        color:
                            widget.product.instock ? Colors.green : Colors.red,
                        fontSize: 12),
                  ),
                ],
              ),

              // Price
              const SizedBox(height: 10),
              Text(
                '\$${widget.product.price.toStringAsFixed(2)}',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 20,
                  color: Colors.grey[700],
                ),
              ),

              // Description
              const SizedBox(height: 20),
              Text(
                widget.product.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              const SizedBox(height: 20),

              // Quantity and Add to Cart Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Quantity Selector
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: widget.product.instock
                            ? AppColors.mainColor
                            : AppColors.mainColor.withOpacity(0.4),
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: widget.product.instock
                                ? AppColors.mainColor
                                : AppColors.mainColor.withOpacity(0.4)),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: widget.product.instock
                            ? AppColors.mainColor
                            : AppColors.mainColor.withOpacity(0.4),
                      ),
                    ],
                  ),

                  // Add to Cart Button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (widget.product.instock) {
                        Provider.of<CartProvider>(context, listen: false)
                            .addItem(
                          widget.product.id,
                          widget.product.price,
                          widget.product.name,
                          quantity: quantity, // Pass the selected quantity here
                        );

                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${widget.product.name} added to cart!',
                                style: const TextStyle(color: Colors.white)),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${widget.product.name} is Out of Stock!',
                                style: const TextStyle(color: Colors.white)),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.product.instock
                          ? const Color.fromARGB(255, 0, 128, 128)
                          : const Color.fromARGB(90, 0, 128, 128),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
