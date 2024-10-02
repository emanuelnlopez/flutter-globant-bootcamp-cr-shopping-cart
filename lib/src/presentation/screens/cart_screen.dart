import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Cart'),
      body: cartProvider.cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                final product = cartProvider.cart[index];
                return ListTile(
                  leading: Image.network(product.imageUrl),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      cartProvider.removeFromCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: 
                        Text('${product.title} removed from cart'),
                        duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        )
      );
    }
  }   