import 'package:flutter/material.dart';
import 'package:shop_app/main.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product.dart';

class UserProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [IconButton(onPressed: () => Navigator.of(context).pushNamed(MyApp.editProductScreen), icon: Icon(Icons.add))],
      ),
      drawer: AppDrawer(),
      body: Padding(
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
    );
  }
}
