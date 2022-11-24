import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order.dart';
import '../models/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
      var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final token = Provider.of<Auth>(context).token;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: _isLoading? const Center(child: CircularProgressIndicator()): cart.totalAmount.toInt() != 0 ? Column(
        children: [
           Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: cart.totalAmount<=0 || _isLoading? null : () async{
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalAmount,token);
                      setState(() {
                        setState(() {
                          _isLoading =false;
                        });
                      });
                      cart.clearCart();
                      // Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Text(
                      "Order Now",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: ((context, index) => CartItem(
                cart.items.values.toList()[index],
                cart.items.keys.toList()[index])),
            itemCount: cart.itemCount,
          ))
        ],
      ): Center(child: Text('Your Cart Is Empty!',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),),),
    );
  }
}
