import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static String routeName = '/orders_screen'; 

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Your Orders'),
        ),
      body: ListView.builder(
            itemBuilder: ((context, index) => OrderItem(order: ordersData.orders[index])),
            itemCount: ordersData.orders.length,
        ),
    );
  }
}
