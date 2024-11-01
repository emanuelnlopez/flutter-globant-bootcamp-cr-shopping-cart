import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';
import 'thankyou_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _navigateToThankYouScreen(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).clearCart();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ThankYouScreen()),
      (route) => route.isFirst,
    );
  }

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
            child: Text('Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}', 
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Choose a payment method:', style: TextStyle(fontSize: 18)),
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Credit Card'),
            onTap: () => _navigateToThankYouScreen(context),
          ),
          ListTile(
            leading: Icon(Icons.paypal_outlined),
            title: Text('PayPal'),
            onTap: () => _navigateToThankYouScreen(context),
          ),
          ListTile(
            leading: Icon(Icons.monetization_on_outlined),
            title: Text('Cash on Delivery'),
            onTap: () => _navigateToThankYouScreen(context),
          ),
        ],
      ),
    );
  }
}