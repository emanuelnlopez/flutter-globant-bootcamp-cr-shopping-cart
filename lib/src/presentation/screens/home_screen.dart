import 'package:flutter/material.dart';
import '../../services/api_service.dart'; 
import 'product_list_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/theme_switcher.dart'; 

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme; 
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final categoryIcons = {
      'jewelery': Icons.diamond,
      'electronics': Icons.devices,
      'women\'s clothing': Icons.woman,
      'men\'s clothing': Icons.man,
      'all_products': Icons.shopping_bag, 
    };

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
            'jewelery': 'Jewellery', // To correct API´s mistake
            'electronics': 'Electronics',
            'women\'s clothing': 'Women\'s Clothing',
            'men\'s clothing': 'Men\'s Clothing',
          };

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5, 
            ),
            padding: const EdgeInsets.all(10),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductListScreen(category: '')), //empty string for 'all products'
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(categoryIcons['all_products'], size: 50, color: Colors.blue),
                        const SizedBox(height: 10),
                        const Text('All Products', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }

              final category = categories[index];
              final displayName = categoryNames[category] ?? category;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListScreen(category: category)),
                  );
                },
                child: Card(
                  //elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Icon(categoryIcons[category], size: 50, color: Colors.blue), 
                      const SizedBox(height: 10),
                      Text(displayName, style: const TextStyle(fontSize: 16)), 
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ThemeSwitcher(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
    );
  }
}