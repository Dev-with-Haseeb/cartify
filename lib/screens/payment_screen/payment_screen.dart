import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/screens/order_confirmation_screen/order_confirmation_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.selectedAddress});

  final String selectedAddress;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  String? _paymentMethod; // Track selected payment method

  // Function to validate the Credit Card Form
  bool validateCardInfo() {
    if (_paymentMethod == 'creditCard') {
      return _formKey.currentState?.validate() ?? false;
    }
    return true; // No validation for Cash on Delivery
  }

  // Function to handle Order Confirmation
  void confirmOrder() async{

    if (_paymentMethod == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Select a Payment Method')),
      );
      return ;
    }

    if (validateCardInfo()) {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final user = FirebaseAuth.instance.currentUser;

      Map<String, dynamic> orderData = {
        'user-id' : user!.uid ,
        'selectedAddress': widget.selectedAddress,
        'paymentMethod': _paymentMethod,
        'cartItems': cart.items.values.map((cartItem) {
          return {
            'id': cartItem.id,
            'title': cartItem.title,
            'quantity': cartItem.quantity,
            'price': cartItem.price,
          };
        }).toList(),
        'orderDate': Timestamp.now(),
      };

      // Add credit card information if payment method is credit card
      if (_paymentMethod == 'creditCard') {
        orderData['creditCardInfo'] = {
          'cardNumber': _cardNumberController.text,
          'expiryDate': _expDateController.text,
          'cvc': _cvcController.text,
          'cardHolderName': _cardHolderController.text,
        };
      }

      // Save to Firestore
      try {
        await FirebaseFirestore.instance.collection('orders').add(orderData);

        cart.clearCart();

        if(!mounted){
          return;
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()),
          (route) => false,
        );
      } catch (error) {
        if(!mounted){
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to place order. Try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _focusScopeNode.unfocus;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Payment'),
          centerTitle: true,
          backgroundColor: AppColors.mainColor,
          foregroundColor: Colors.white,
        ),
        body: FocusScope(
          node: _focusScopeNode,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _paymentMethod = 'creditCard';
                            });
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Radio<String>(
                                        activeColor: AppColors.mainColor,
                                        value: 'creditCard',
                                        groupValue: _paymentMethod,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _paymentMethod = value;
                                          });
                                        },
                                      ),
                                      const Text('Credit Card',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.mainColor)),
                                    ],
                                  ),
                                  if (_paymentMethod == 'creditCard') ...[
                                    const SizedBox(height: 30),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          // Card Number
                                          TextFormField(
                                            controller: _cardNumberController,
                                            decoration: const InputDecoration(
                                              labelText: 'Card Number',
                                              hintText: '1234 5678 9876 5432',
                                              icon: Icon(Icons.credit_card),
                                            ),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter card number';
                                              }
                                              if (value.length != 16) {
                                                return 'Card number must be 16 digits';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          // Expiry Date
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _expDateController,
                                                  decoration: const InputDecoration(
                                                    labelText: 'Exp Date',
                                                    hintText: 'MM/YY',
                                                  ),
                                                  keyboardType: TextInputType.datetime,
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter expiration date';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _cvcController,
                                                  decoration: const InputDecoration(
                                                    labelText: 'CVC',
                                                    hintText: '123',
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter CVC';
                                                    }
                                                    if (value.length != 3) {
                                                      return 'CVC must be 3 digits';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                              
                                          const SizedBox(height: 10),
                                          // Cardholder Name
                                          TextFormField(
                                            controller: _cardHolderController,
                                            decoration: const InputDecoration(
                                              labelText: 'Cardholder Name',
                                              hintText: 'John Doe',
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter cardholder name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Display the Credit Card Form if selected
                              
                        const SizedBox(height: 20),
                        // Cash on Delivery option
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _paymentMethod = 'cashOnDelivery';
                            });
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    activeColor: AppColors.mainColor,
                                    value: 'cashOnDelivery',
                                    groupValue: _paymentMethod,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _paymentMethod = value;
                                      });
                                    },
                                  ),
                                  const Text('Cash on Delivery',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mainColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: confirmOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16),
                    ),
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
