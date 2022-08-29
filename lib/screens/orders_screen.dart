import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static String routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error Ocurred!'),
              );
            } else {
              return Consumer<Orders>(
                  builder: ((context, ordersData, child) => ListView.builder(
                        itemBuilder: ((context, index) =>
                            OrderItem(order: ordersData.orders[index])),
                            itemCount: ordersData.orders.length,
                      )));
            }
          },
        ));
  }
}
