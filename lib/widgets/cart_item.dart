import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart' as cartI;

class CartItem extends StatelessWidget {
  cartI.CartItem cartItem;
  final String productId;

  CartItem(this.cartItem, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: ((direction) {
        Provider.of<cartI.Cart>(context, listen: false).removeItem(productId);
      }),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('A1 Collection',style: TextStyle(fontWeight: FontWeight.bold),),
                  content: const Text('Are You Sure You Want To Delete Item?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text('No',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green))),
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text('Yes',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                  ],
                ));
      },
      key: ValueKey(cartItem.id),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          size: 25,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: FittedBox(
              fit: BoxFit.contain,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "\$${cartItem.price}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
            title: Text(cartItem.title),
            subtitle: Text('Total: \$${cartItem.quantity * cartItem.price}'),
            trailing: Text('${cartItem.quantity} x'),
          ),
        ),
      ),
    );
  }
}
