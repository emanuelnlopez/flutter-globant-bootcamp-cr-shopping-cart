import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';
import '../../providers/cart_provider.dart';
import 'product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';

class ProductListScreen extends StatelessWidget {
  final String category;

  ProductListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    Map<String, String> categoryCorrections = {
      'electronics' : 'Electronics',
      'jewelery': 'Jewellery',
      'men\'s clothing': 'Men\'s Clothing',
      'women\'s clothing': 'Women\'s Clothing',
    };

    return Scaffold(
      appBar: CustomAppBar(title: '${category.isEmpty ? "All Products" : categoryCorrections[category] ?? category}'),
      body: FutureBuilder<List<Product>>(
        future: category.isEmpty ? ApiService.fetchProducts() : ApiService.fetchProductsByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Column(
                children: [
                  ListTile(
                    leading: Image.network(product.imageUrl),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Text(product.title),
                        Text('\$${product.price}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8), 
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(product),
                              ),
                            );
                          },
                          child: const Text('View Details'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
                            textStyle: TextStyle(fontSize: 14), 
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(color: Colors.grey),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

