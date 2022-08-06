import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              //  ChangeNotifierProvider( \\ in case context is needed to the crerate widget (or creating new widget)
              value:
                  products[index], //   create: ((context) => products[index]),
              child: ProductItem(
                  // id: products[index].id,
                  // title: products[index].title,
                  // imageUrl: products[index].imageUrl
                  ),
            ));
  }
}
