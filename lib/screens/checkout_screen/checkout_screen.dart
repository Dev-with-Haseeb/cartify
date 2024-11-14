import 'package:cartify/models/address_model.dart';
import 'package:cartify/providers/cart_provider.dart';
import 'package:cartify/widgets/address_form.dart';
import 'package:cartify/screens/payment_screen/payment_screen.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  List<Address> _addresses = [];
  Address? _selectedAddress;
  bool _showAddressForm = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final addresses = await fetchAddresses(userId);
      setState(() {
        _addresses = addresses;
        _selectedAddress = addresses.isNotEmpty ? addresses[0] : null;
      });
    }
  }

  void _toggleAddressForm() {
    setState(() {
      _showAddressForm = !_showAddressForm;
    });
  }

  Future<void> deleteAddress(String addressId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();
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
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: AppColors.mainColor,
          foregroundColor: Colors.white,
        ),
        body: FocusScope(
          node: _focusScopeNode,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address Selection Section
                  const Text(
                    'Delivery Address',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  if (_addresses.isNotEmpty && !_showAddressForm)
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<Address>(
                            hint: const Text('Select Address'),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: _selectedAddress,
                            items: _addresses
                                .map((address) => DropdownMenuItem<Address>(
                                      value: address,
                                      child: Text(
                                        '${address.label ?? 'Address'}: ${address.street}, ${address.city}, ${address.state}, ${address.zipCode}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (Address? newValue) {
                              setState(() => _selectedAddress = newValue);
                            },
                          )),
                    ),
                  if (!_showAddressForm)
                    TextButton.icon(
                      icon: const Icon(Icons.add,
                          color: Color.fromARGB(255, 145, 140, 140)),
                      label: const Text(
                        'Add New Address',
                        style: TextStyle(
                            color: Color.fromARGB(255, 145, 140, 140)),
                      ),
                      onPressed: _toggleAddressForm,
                    ),
                  if (_showAddressForm)
                    AddressForm(
                      onSave: (newAddress) async {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                          _loadAddresses();
                          _toggleAddressForm();
                        }
                      },
                      toggleAddressForm: _toggleAddressForm,
                    ),
                  const SizedBox(height: 20),

                  // Order Summary Section
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: cart.itemCount,
                                itemBuilder: (context, i) {
                                  final cartItem =
                                      cart.items.values.toList()[i];
                                  return ListTile(
                                    title: Text(
                                      cartItem.title,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    trailing: Text(
                                      '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  );
                                },
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_addresses.isNotEmpty) {

                        final String selectedAddressString = "${_selectedAddress!.street}, ${_selectedAddress!.city}, ${_selectedAddress!.state}, ${_selectedAddress!.zipCode}";


                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: PaymentScreen(selectedAddress: selectedAddressString,),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please Enter Your Address')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Proceed to Payment',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
