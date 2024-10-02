import 'package:flutter/material.dart';
import '../../services/api_service.dart'; 
import 'product_list_screen.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home'),
      body: FutureBuilder<List<String>>(
        future: ApiService.fetchCategories(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          final categories = snapshot.data!;
          
          final categoryNames = {
            'jewelery': '  Jewellery', // To correct API´s mistake
            'electronics': '  Electronics',
            'women\'s clothing': '  Women\'s Clothing',
            'men\'s clothing': '  Men\'s Clothing',
          };

          return ListView.builder(
            itemCount: categories.length + 1, 
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return Column(
                  children: [
                    ListTile(
                      title: const Text('  All Products'), 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductListScreen(category: '')), // empty string for 'all products'
                        );
                      },
                    ),
                  ],
                );
              }

              final category = categories[index];
              final displayName = categoryNames[category] ?? category; 
              return Column(
                children: [
                  ListTile(
                    title: Text(displayName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductListScreen(category: category)), 
                      );
                    },
                  ),
                  const Divider(color: Colors.grey), 
                ],
              );
            },
          );
        },
      ),
    );
  }
}