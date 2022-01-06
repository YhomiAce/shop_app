import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> products = Product.getProducts();
  // var _showFavoritesOnly = false;

  List<Product> get favoriteItems {
    return products.where((item) => item.isFavorites).toList();
  }

  List<Product> get getProducts {
    // if (_showFavoritesOnly) {
    //   return products.where((item) => item.isFavorites).toList();
    // }
    return [...products];
  }

  Product findById(String id) {
    return products.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
