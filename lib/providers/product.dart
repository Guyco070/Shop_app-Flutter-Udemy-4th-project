import 'package:flutter/cupertino.dart';

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

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
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
