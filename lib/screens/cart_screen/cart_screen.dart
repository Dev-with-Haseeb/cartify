import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/screens/checkout_screen/checkout_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.mainColor,
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.mainColor,
                    child: Text(
                      '${cartItem.quantity}x',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    cartItem.title,
                    style: const TextStyle(color: AppColors.mainColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '\$${cartItem.price}',
                    style: const TextStyle(color: AppColors.mainColor),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: AppColors.mainColor,
                        ),
                        onPressed: () {
                          cart.removeSingleItem(cartItem.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.mainColor,
                        ),
                        onPressed: () {
                          cart.removeItem(cartItem.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (cart.itemCount == 0) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add something in your cart'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const CheckoutScreen(),
                        withNavBar: false, // Hides the bottom navigation bar
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
