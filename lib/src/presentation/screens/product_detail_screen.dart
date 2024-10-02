

import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: product.title),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'), 
              onPressed: () {
                // add product to cart 
                Provider.of<CartProvider>(context, listen: false).addToCart(product);
                //to show message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: 
                  Text('${product.title} added to cart'),
                  duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
