import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart.dart' show Cart;
import 'package:shop_app/widgets/cart_item.dart';

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
                      label: Text('\$${cart.totalAmount}',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleSmall!.color,
                          )),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(onPressed: () {}, child: const Text('ORDER NOW'))
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
