import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
              create: ((context) => Products())), // in case That we creating a new wiget its better use create and not value
        ChangeNotifierProvider(
              create: ((context) => Cart())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: const TextTheme(
            titleSmall: TextStyle(
              color: Colors.white,
            )
          ),
          primarySwatch: Colors.purple,
          // ignore: deprecated_member_use
          accentColor: Colors.deepOrange,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          CartSceen.routeName:(context) => const CartSceen(),
        },
      )
    );
  }
}