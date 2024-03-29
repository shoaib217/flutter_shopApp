import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders(String? token, String? userId) async {
    final url = Uri.parse('$base_url/orders/$userId.json?auth=$token');

    final response = await http.get(url);
    print(json.decode(response.body));
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extractData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  imageUrl: item['imageUrl'] ?? "",
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    print('loadedOrders - $loadedOrders');
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total,
      String? token, String? userId) async {
    final url = Uri.parse('$base_url/orders/$userId.json?auth=$token');

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'price': cp.price,
                  'quantity': cp.quantity,
                  'title': cp.title,
                  'imageUrl': cp.imageUrl
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));

    notifyListeners();
  }
}
