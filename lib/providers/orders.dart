import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    const url = 'https://shopapp-438a8-default-rtdb.firebaseio.com/orders.json';
    try {
      final res = await http.get(url);
      final List<OrderItem> loadedOrder = [];
      final extractedData = json.decode(res.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderdata) {
        loadedOrder.add(
          OrderItem(
            id: orderId,
            amount: orderdata['amount'],
            dateTime: DateTime.parse(
              orderdata['dateTime'],
            ),
            products: (orderdata['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shopapp-438a8-default-rtdb.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cart) => {
                    'id': cart.id,
                    'title': cart.title,
                    'quantity': cart.quantity,
                    'price': cart.price,
                  })
              .toList()
        }),
      );
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: cartProducts),
      );
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
