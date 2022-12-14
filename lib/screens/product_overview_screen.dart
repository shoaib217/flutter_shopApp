import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/product_item.dart';
import '../providers/products_provider.dart';
import '../models/cart.dart';

enum FilterOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorites = false;
  var _init = true;
  var _isLoading = false;
  // final List<Product> loadedProduct = ;
  var scaffoldMessenger;
void init(BuildContext context){
   scaffoldMessenger =ScaffoldMessenger.of(context);
}

@override
  void didChangeDependencies() {
    if(_init){
      final token = Provider.of<Auth>(context,listen: false).token;
      final userId = Provider.of<Auth>(context,listen: false).userId;
      setState(() {
        _isLoading = true;
      });
        Provider.of<Products>(context).fetchData(token,userId).then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((error){
          scaffoldMessenger.showSnackBar(SnackBar(content: Text(error.toString())));
          setState(() {
          _isLoading = false;
          });
        });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('A1 Collection'),
        actions: [
          Container(
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(MyApp.cartScreen);
                  },
                ),
                Positioned(
                  right: sqrt1_2,
                  child: Text(cart.itemCount.toString()),
                )
              ],
            ),
          ),
          PopupMenuButton(
            onSelected: (value) => setState(() {
              value == FilterOptions.favorites
                  ? _showFavorites = true
                  : _showFavorites = false;
            }),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),

          // ignore: sort_child_properties_last
          /* Consumer<Cart>(
            builder: (context, value, ch) => Badge(
                value: value.itemCount.toString(),
                color: Theme.of(context).colorScheme.secondary,
              child: Icon(Icons.cabin),
              ),
          ), */
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ProductGrid(_showFavorites),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final bool showFav;
  ProductGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFav ? productData.favorite : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
