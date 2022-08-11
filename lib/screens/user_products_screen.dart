import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static String routeName = '/user_products';
  @override
  Widget build(BuildContext context) {
    final productsDate = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: ((_, index) => Column(
            children: [
              UserProductItem(title: productsDate.items[index].title, imageUrl: productsDate.items[index].imageUrl),
              const Divider(),
            ],
          )),
          itemCount: productsDate.items.length,
        ),
      ),
    );
  }
}
