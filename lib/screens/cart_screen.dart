import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import './orders_screen.dart';
import '../widgets/cart_item.dart';

class CartSceen extends StatelessWidget {
  const CartSceen({Key? key}) : super(key: key);
  static String routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      width: 10,
                    ),
                    const Spacer(),
                    Chip(
                      label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleSmall!.color,
                          )),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) => CartItem(
              id: cart.items.values.toList()[index].id,
              productId: cart.items.keys.toList()[index],
              title: cart.items.values.toList()[index].title,
              quantity: cart.items.values.toList()[index].quantity,
              price: cart.items.values.toList()[index].price,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading 
    ? const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: CircularProgressIndicator(),
    ) : TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                if (widget.cart.items.isNotEmpty) {
                  await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cart.items.values.toList().cast(),
                      widget.cart.totalAmount);
                  setState(() {
                    _isLoading = true;
                  });
                  widget.cart.clear();
                  Navigator.pushNamed(context, OrdersScreen.routeName);
                }
              },
        child: const Text('ORDER NOW'));
  }
}
