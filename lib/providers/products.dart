import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> products = []; // Product.getProducts();
  // var _showFavoritesOnly = false;
  final String authTken;
  Products(this.authTken, this.products);

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

  Future<void> fetchAllProducts() async {
    final url =
        'https://shopapp-438a8-default-rtdb.firebaseio.com/products.json?auth=$authTken';
    try {
      final res = await http.get(url);
      print(res.statusCode);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorites: prodData['isFavorite'],
        ));
      });
      products = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-438a8-default-rtdb.firebaseio.com/products.json?auth=$authTken';
    // return http
    //     .post(
    //   url,
    //   body: json.encode({
    //     "title": product.title,
    //     "description": product.description,
    //     'price': product.price,
    //     'imageUrl': product.imageUrl,
    //     'isFavorite': product.isFavorites,
    //   }),
    // )
    //     .then((res) {
    //   print(json.decode(res.body));
    //   final newProduct = Product(
    //     price: product.price,
    //     title: product.title,
    //     description: product.description,
    //     imageUrl: product.imageUrl,
    //     id: json.decode(res.body)['name'],
    //   );
    //   // products.insert(0, newProduct); // add product at the begining
    //   products.add(newProduct); // add at the end
    //   notifyListeners();
    // }).catchError((error) {
    //   print(error);
    //   throw error;
    // });

    // Async // Await
    try {
      final res = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorites,
        }),
      );

      print(json.decode(res.body));
      final newProduct = Product(
        price: product.price,
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(res.body)['name'],
      );
      // products.insert(0, newProduct); // add product at the begining
      products.add(newProduct); // add at the end
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = products.indexWhere((prod) => prod.id == id);

    final url =
        'https://shopapp-438a8-default-rtdb.firebaseio.com/products/$id.json?auth=$authTken';
    try {
      if (prodIndex >= 0) {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
              'isFavorite': newProduct.isFavorites,
            }));

        products[prodIndex] = newProduct;
      } else {
        print('404... product not found');
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopapp-438a8-default-rtdb.firebaseio.com/products/$id.json?auth=$authTken';

    final existingProductIndex = products.indexWhere((prod) => prod.id == id);
    var existingProduct = products[existingProductIndex];
    products.removeAt(existingProductIndex);
    notifyListeners();
    // products.removeWhere((prod) => prod.id == id);
    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Product');
    }
    existingProduct = null;
  }
}
