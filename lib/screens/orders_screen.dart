import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndSetOrders(auth.token, auth.userId),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text(
                    'No Orders Found.',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return Consumer<Orders>(
                  builder: ((ctx, orderData, child) => ListView.builder(
                        itemBuilder: (ctx, index) =>
                            OrderItem(orderData.orders[index]),
                        itemCount: orderData.orders.length,
                      )),
                );
              }
            }
          }),
    );
  }
}
