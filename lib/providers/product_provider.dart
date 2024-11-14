import 'package:cartify/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _products = [];
  bool _isLoading = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final querySnapshot = await _firestore.collection('products').get();
      _products = querySnapshot.docs.map((doc) {
        return Product(
          id: doc['id'],
          name: doc['name'],
          price: doc['price'],
          imageUrl: doc['imageUrl'],
          description: doc['description'],
          categoryId: doc['categoryId'],
          instock: doc['instock'],
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
