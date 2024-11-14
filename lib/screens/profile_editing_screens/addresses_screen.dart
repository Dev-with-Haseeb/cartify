import 'package:cartify/models/address_model.dart';
import 'package:cartify/widgets/address_form.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  List<Address> _addresses = [];
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
      _loadAddresses();
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
          title: const Text('My Addresses'),
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
                  const Text(
                    'Delivery Addresses',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  if (_addresses.isNotEmpty && !_showAddressForm)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        final address = _addresses[index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              '${address.label ?? 'Address'}: ${address.street}, ${address.city}, ${address.state}, ${address.zipCode}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.mainColor),
                              onPressed: () async {
                                await deleteAddress(address.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 10),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
