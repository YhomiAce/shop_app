import 'package:flutter/material.dart';

import '../models/product.dart';



class Products with ChangeNotifier {
  List<Product> _items = Product.getProducts();

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
