import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorites;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorites = false,
  });

  void _setFavValue(bool newValue) {
    isFavorites = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorites(String token, String userId) async {
    final oldStatus = isFavorites;
    isFavorites = !isFavorites;
    notifyListeners();
    final url =
        'https://shopapp-438a8-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final res = await http.put(url, body: json.encode(isFavorites));
      if (res.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }

  static List<Product> getProducts() => [
        Product(
          id: 'p1',
          title: 'Red Shirt',
          description: 'A red shirt - it is pretty red!',
          price: 29.99,
          imageUrl:
              'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
        ),
        Product(
          id: 'p2',
          title: 'Trousers',
          description: 'A nice pair of trousers.',
          price: 59.99,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
        ),
        Product(
          id: 'p3',
          title: 'Yellow Scarf',
          description: 'Warm and cozy - exactly what you need for the winter.',
          price: 19.99,
          imageUrl:
              'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
        ),
        Product(
          id: 'p4',
          title: 'A Pan',
          description: 'Prepare any meal you want.',
          price: 49.99,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
        ),
      ];
}
