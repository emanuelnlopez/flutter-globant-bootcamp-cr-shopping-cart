import 'dart:async';

import 'package:shopping_cart_app/src/models/product.dart';
import 'package:shopping_cart_app/src/services/api_service.dart';

abstract class Disposable {
  void dispose();
}

class ProductProvider implements Disposable {
  ProductProvider({required this.apiService});

  final ApiService apiService;
  final _categoriesStreamController =
      StreamController<List<String>>.broadcast();
  final _productsStreamController = StreamController<List<Product>>.broadcast();

  Stream<List<Product>> get productsStream => _productsStreamController.stream;
  Stream<List<String>> get categoriesStream =>
      _categoriesStreamController.stream;

  void getCategories() async {
    try {
      final categories = await apiService.fetchCategories();
      _categoriesStreamController.add(categories);
    } catch (error) {
      _categoriesStreamController.addError(error);
    }
  }

  void getProducts({String? category}) async {
    try {
      late List<Product> products;
      if (category?.isNotEmpty == true) {
        products = await apiService.fetchProducts();
      } else {
        products = await apiService.fetchProducts();
      }
      _productsStreamController.add(products);
    } catch (error) {
      _productsStreamController.addError(error);
    }
  }
  
  @override
  void dispose() {
    _categoriesStreamController.close();
    _productsStreamController.close();
  }
}
