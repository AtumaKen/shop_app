import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
   List<OrderItem> _orders = [];
   final String authToken;
   final String userId;

  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = "https://shop-app-flutter-tut.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();
    try{
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(json.decode(response.body)["name"], total, cartProducts,
            timeStamp));
    notifyListeners();
    }catch (error){
      throw (error);
    }
  }

  Future<void> fetchAndSetOrder() async {
    final url = "https://shop-app-flutter-tut.firebaseio.com/orders/$userId.json?auth=$authToken";
    try {
    final response = await http.get(url);
    final List<OrderItem> loadOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadOrders.add(OrderItem(
          orderId,
          orderData["amount"],
          (orderData["products"] as List<dynamic>).map((item) => CartItem(
            id: item["id"], price: item["price"], quantity: item["quantity"], title: item["title"]
          )).toList(),
          DateTime.parse(orderData["dateTime"])));
      _orders = loadOrders.reversed.toList();
      notifyListeners();
    });
    } catch (error){
      throw (error);
    }
  }
}
