import 'package:cartify/models/address_model.dart';
import 'package:cartify/widgets/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  const AddressForm(
      {required this.onSave, super.key, required this.toggleAddressForm});

  final Function(Address) onSave;
  final Function() toggleAddressForm;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  String _street = '';
  String _city = '';
  String _state = '';
  String _zipCode = '';

  void _saveAddress() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    final address = Address(
      id: '',
      street: _street,
      city: _city,
      state: _state,
      zipCode: _zipCode,
    );

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await saveAddress(address, userId);
        widget.onSave(address);
      } catch (e) {
        if(!mounted){
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address Alredy Exists')),
        );
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                ),
                onSaved: (value) => _street = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a street address' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
                onSaved: (value) => _city = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a city' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'State',
                ),
                onSaved: (value) => _state = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a state' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Zip Code',
                ),
                onSaved: (value) => _zipCode = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a zip code' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.toggleAddressForm();
                    },
                    style: TextButton.styleFrom(foregroundColor: AppColors.mainColor),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16),),
                  ),
                  const SizedBox(width: 3),
                  ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: const Text(
                      'Save Address',
                      style: TextStyle(color: Colors.white),
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
