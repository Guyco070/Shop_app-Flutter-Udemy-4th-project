import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/edit_product_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_products_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of   application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => Auth())), // must be before ChangeNotifierProxyProvider<Auth, Products>
        ChangeNotifierProxyProvider<Auth, Products>(
                update: ((context, auth, previousProducts) => Products(auth.token, auth.userId,(previousProducts  as Products).items)),
                create: (context) => Products(null, null,[]),
              ), // in case That we creating a new wiget its better use create and not value
        ChangeNotifierProvider(
              create: ((context) => Cart())),
        ChangeNotifierProxyProvider<Auth, Orders>(
                update: ((context, auth, previousOrders) => Orders(auth.token, auth.userId, (previousOrders  as Orders).orders)),
                create: (context) => Orders(null, null, []),
              ),
      ],
      child: Consumer<Auth>(builder: (context, auth, _) =>  MaterialApp(
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
          home: auth.isAuth ? const ProductsOverviewScreen() 
          : FutureBuilder(
                future: auth.tryAutoLogin(), 
                builder: (context, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? const SplashScreen() : AuthScreen(),
              ),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
            CartSceen.routeName:(context) => const CartSceen(),
            OrdersScreen.routeName:(context) => const OrdersScreen(),
            UserProductsScreen.routeName:(context) => const UserProductsScreen(),
            EditProductScreen.routeName:(context) => const EditProductScreen(),
          },
        ),
      )
    );
  }
}