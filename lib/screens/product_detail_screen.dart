import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
/* Product product;
ProductDetailScreen(this.product); */

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            // ignore: sort_child_properties_last
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            height: 300,
            width: double.infinity,
          )
        ],
      )),
    );
  }
}
