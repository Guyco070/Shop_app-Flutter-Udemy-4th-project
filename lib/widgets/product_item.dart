import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({Key? key, required this.id, required this.title, required this.imageUrl}) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context);
    final Cart cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer(
              // video 200
              builder: (context, value, _) => IconButton(
                // (context, value, child) - in case there is a child we don't want to rebuild
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: product.toggleFavoriteStatus,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => cart.addItem(product.id, product.price, product.title),
              color: Theme.of(context).accentColor,
            ),
          ),
          child: GestureDetector(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                    arguments: product.id);
              }),
        ));
  }
}
