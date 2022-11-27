import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_Screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String productDetailScreen = "/product_detail_screen";
  static const String cartScreen = "/cart_Screen";
  static const String orderScreen = "/order_screen";
  static const String userProductScreen = "/user_product_screen";
  static const String editProductScreen = "/edit_product_screen";
  static const String authenticationSceen = '/auth';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'A1 Collection',
          theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan)
                  .copyWith(secondary: Colors.orange)),
          home: auth.isAuthenticated
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: ((ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
                ),
          routes: {
            productDetailScreen: (ctx) => ProductDetailScreen(),
            cartScreen: (ctx) => const CartScreen(),
            orderScreen: ((ctx) => OrderScreen()),
            userProductScreen: (ctx) => UserProductScreen(),
            editProductScreen: ((ctx) => const EditProductScreen())
          },
        ),
      ),
    );
  }
}
