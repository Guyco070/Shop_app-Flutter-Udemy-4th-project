import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static String routeName = '/orders_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) async { // insted of using then mehod
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await 
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_){
      setState(() {
        _isLoading = false;
      });
    });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemBuilder: ((context, index) =>
            OrderItem(order: ordersData.orders[index])),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
