import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/auth.dart';
import '../models/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final token = Provider.of<Auth>(context).token;
    final userId = Provider.of<Auth>(context).userId;
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(MyApp.productDetailScreen, arguments: product),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            leading: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: (() {
                product.toggleFavoriteStatus(token, userId);
              }),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.shopping_cart),
              onPressed: (() {
                cart.addItem(product.id.toString(), product.price,
                    product.title, product.imageUrl);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added Item To Cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: (() =>
                        cart.removeSingleItem(product.id.toString())),
                  ),
                ));
              }),
            ),
            backgroundColor: Colors.black87,
          ),
          child: Hero(
            tag: product.id.toString(),
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
