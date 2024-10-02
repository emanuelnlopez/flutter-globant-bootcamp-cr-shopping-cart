import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Checkout'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                final product = cartProvider.cart[index];
                return ListTile(
                  leading: Image.network(product.imageUrl),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 24)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Choose a payment method:', style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            title: Text('Credit Card'),
            onTap: () {
              // Code for credit card payment 
            },
          ),
          ListTile(
            title: Text('PayPal'),
            onTap: () {
              // Code for PayPal payment
            },
          ),
          ListTile(
            title: Text('Cash on Delivery'),
            onTap: () {
              // Code for cash payment 
            },
          ),
        ],
      ),
    );
  }
}