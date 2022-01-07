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

  void addProduct(Product product) {
    final newProduct = Product(
      price: product.price,
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    // products.insert(0, newProduct); // add product at the begining
    products.add(newProduct); // add at the end
    notifyListeners();
  }
}
