import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../models/Category.dart';
import '../models/Order.dart' as order_model;
import '../services/ApiService.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  order_model.Order? _cart;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  order_model.Order? get cart => _cart;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts({int? categoryId, String? search}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getProducts(categoryId: categoryId, search: search);
      _products = (response.data as List).map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      debugPrint('Fetch Products Error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _apiService.getCategories();
      _categories = (response.data as List).map((c) => Category.fromJson(c)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch Categories Error: $e');
    }
  }

  Future<void> fetchCart() async {
    try {
      final response = await _apiService.getCart();
      _cart = order_model.Order.fromJson(response.data);
      notifyListeners();
    } catch (e) {
      debugPrint('Fetch Cart Error: $e');
    }
  }

  Future<void> updateCart(int productId, String action) async {
    try {
      await _apiService.updateCart(productId, action);
      await fetchCart();
    } catch (e) {
      debugPrint('Update Cart Error: $e');
    }
  }

  Future<bool> processOrder(Map<String, dynamic> shippingData) async {
    try {
      final response = await _apiService.checkout(shippingData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _cart = null; // Clear local cart
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Process Order Error: $e');
    }
    return false;
  }
}
