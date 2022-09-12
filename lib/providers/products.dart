import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;
  Products(this.authToken, this.userId, this._items);
  String? authToken;
  String? userId;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String productId) {
    return items.firstWhere((element) => element.id == productId);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    String filterString = filterByUser ?'orderBy="creator"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shop-app-flutter-73550-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
    try {
      final response = await get(url);
      final extractData = jsonDecode(response.body) as Map<String, dynamic>;

      url = Uri.parse(
          'https://shop-app-flutter-73550-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await get(url);
      final favoriteDate = jsonDecode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'] as String,
          description: prodData['description'] as String,
          price: prodData['price'] as double,
          imageUrl: prodData['imageUrl'] as String,
          isFavorite: favoriteDate == null ? false : favoriteDate[prodId] ?? false,
        ));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-flutter-73550-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response =
          await post(url, body: jsonEncode(Product.toObjectWithCreator(userId!, product)));
      _items.add(Product.createUpdatedProduct(
          'id', jsonDecode(response.body)['name'], product));
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow; // same as throw error;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final int prodIndex =
        _items.indexWhere((element) => element.id == productId);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-flutter-73550-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');
      await patch(url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://shop-app-flutter-73550-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == productId);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
