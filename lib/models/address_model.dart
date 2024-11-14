import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String? label;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.label,
  });

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'label': label,
    };
  }

  factory Address.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Address(
      id: doc.id,
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      zipCode: data['zipCode'] ?? '',
      label: data['label'],
    );
  }
}


Future<bool> addressExists(Address address, String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('addresses')
      .where('street', isEqualTo: address.street)
      .where('city', isEqualTo: address.city)
      .where('state', isEqualTo: address.state)
      .where('zipCode', isEqualTo: address.zipCode)
      .get();

  return snapshot.docs.isNotEmpty;
}

Future<void> saveAddress(Address address, String userId) async {
  final exists = await addressExists(address, userId);
  if (!exists) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(address.toMap());
  } else {
    throw Exception('Address already exists');
  }
}


Future<List<Address>> fetchAddresses(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('addresses')
      .get();

  return snapshot.docs.map((doc) => Address.fromFirestore(doc)).toList();
}
