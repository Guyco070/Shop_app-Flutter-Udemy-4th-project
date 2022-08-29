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

/*
// using FutureBuilder without rerun the Future method. (at other cases)
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static String routeName = '/orders_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future:
              _ordersFuture,
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
*/
