import 'package:flutter/material.dart';
import 'package:shopping_cart_app/src/providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import 'product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';

class ProductListScreen extends StatefulWidget {
  final String category;

  const ProductListScreen({
    required this.category,
    super.key,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late String _category;
  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
    _productProvider = context.read<ProductProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productProvider.getProducts(category: _category);
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> categoryCorrections = {
      'electronics': 'Electronics',
      'jewelery': 'Jewellery',
      'men\'s clothing': 'Men\'s Clothing',
      'women\'s clothing': 'Women\'s Clothing',
    };
    return Scaffold(
      appBar: CustomAppBar(title: '${_category.isEmpty ? "All Products" : categoryCorrections[_category] ?? _category}'),
      body: StreamBuilder(
        stream: _productProvider.productsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    Image.network(product.imageUrl, fit: BoxFit.cover, height: 100),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                      child: Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blueAccent,
                          ),
                      ),
                    ),
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
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, 
                        children: const [
                          Icon(Icons.add_shopping_cart),
                          SizedBox(width: 8), 
                          Text('Add to Cart'),
                        ],
                      ),
                    )

                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}