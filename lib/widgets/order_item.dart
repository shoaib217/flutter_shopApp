import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;
    bool _expanded = false;

  OrderItem(this.orderItem);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    print("expanded = ${widget._expanded}");
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: widget._expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  widget._expanded = !widget._expanded;
                });
              },
            ),
          ),
          if (widget._expanded)
            Container(
              height: min(widget.orderItem.products.length * 20.0 + 25, 180),
              child: ListView.builder(
                itemBuilder: ((context, index) => ListTile(
                      leading: Text(widget.orderItem.products[index].title),
                      trailing: Text(
                          '${widget.orderItem.products[index].quantity}x \$${widget.orderItem.products[index].price}'),
                    )),
                    itemCount: widget.orderItem.products.length,
              ),
            )
        ],
      ),
    );
  }
}
