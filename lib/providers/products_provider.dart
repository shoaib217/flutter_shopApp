import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorite {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Future<void>fetchData(String? token,String? userId,[filterUser = false]) async{
    print('token - $token');
    final filterString = filterUser? 'orderBy="creatorId"&equalTo="$userId':'';
    var url = Uri.parse(
        '$base_url/products.json?auth=$token&$filterString"');
    try{
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String,dynamic>;
      if(extractData ==null){
        return;
      }
      url = Uri.parse(
        '$base_url/UserFavorites/$userId.json?auth=$token');

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProduct =[];
      extractData.forEach((prodID, value) { 
        loadedProduct.add(Product(
          id: prodID,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          isFavorite: favoriteData == null ? false: favoriteData[prodID] ?? false,
          imageUrl: value['imageUrl']
        ));
      });
      _items = loadedProduct;
      print(_items);
      notifyListeners();
    }catch(error){
      print(error);
      throw error;
    }
  }

  Future<void>addProduct(Product product, String? token,String? userId) {
    final url = Uri.parse(
        '$base_url/products.json?auth=$token');
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId
      }),
    )
        .then((response) {
      final addProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _items.add(addProduct);
      notifyListeners();
    }).catchError((error){
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct, String? token) async{
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        '$base_url/products/$id.json?auth=$token');
      
      await http.patch(url,body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('.....');
    }
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> removeProduct(String id, String? token) async {
    final url = Uri.parse(
        '$base_url/products/$id.json?auth=$token');
    final existingProductIndex =_items.indexWhere((element) => element.id ==id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode>=400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('product could not delete.');
    }else{
      existingProduct =null;
    }
  }
}
