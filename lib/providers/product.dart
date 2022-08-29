import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  static Object toObject(Product product) => {
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      };

  static Product createUpdatedProduct(
      String toUpdate, Object newValue, Product old) {
    Map<String, Object> newProductValues = {
      'id': old.id,
      'title': old.title,
      'description': old.description,
      'price': old.price,
      'imageUrl': old.imageUrl,
      'isFavorite': old.isFavorite,
    };

    newProductValues[toUpdate] = newValue;

    return Product(
      id: newProductValues['id'] as String,
      title: newProductValues['title'] as String,
      description: newProductValues['description'] as String,
      price: newProductValues['price'] as double,
      imageUrl: newProductValues['imageUrl'] as String,
      isFavorite: newProductValues['isFavorite'] as bool,
    );
  }

  void updateFavValue() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    updateFavValue();
    final url = Uri.parse(
        'https://shop-app-flutter-73550-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final response = await patch(url,
        body: jsonEncode({
          'isFavorite': isFavorite,
        }));
    if (response.statusCode >= 400) {
      updateFavValue();
      throw HttpException('Could not update favorite.');
    }
  }

  @override
  String toString() {
    String str = 'Product: \n';
    str += 'id: $id\n';
    str += 'title: $title\n';
    str += 'description: $description\n';
    str += 'price: $price\n';
    str += 'imageUrl: $imageUrl\n';
    str += 'isFavorite: $isFavorite\n';
    return str;
  }
}
