import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/providers/auth.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product.dart';

class UserProductScreen extends StatelessWidget {

Future<void> _refreshProduct(BuildContext context) async {
      final token = Provider.of<Auth>(context,listen: false).token;
      final userId = Provider.of<Auth>(context,listen: false).userId;

await Provider.of<Products>(context,listen: false).fetchData(token,userId);
}

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [IconButton(onPressed: () => Navigator.of(context).pushNamed(MyApp.editProductScreen), icon: Icon(Icons.add))],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: ((context, i) => Column(
              children: [
                UserProduct(
                    productData.items[i].title, productData.items[i].imageUrl,productData.items[i].id.toString()),
                    const Divider()
              ],
            )),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
