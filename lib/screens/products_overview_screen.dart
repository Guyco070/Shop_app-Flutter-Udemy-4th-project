import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    //   productContainer.showFavoritesOnly();
                    _showOnlyFavorites = true;
                  } else {
                    //   productContainer.showAll();
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: FilterOptions.Favorites,
                        child: Text('Only Favorites')),
                    const PopupMenuItem(
                        value: FilterOptions.All, child: Text('Show all')),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child as Widget,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, CartSceen.routeName),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
      ? const Center(
        child:  CircularProgressIndicator(),
      ) 
      : ProductsGrid(_showOnlyFavorites),
    );
  }
}
