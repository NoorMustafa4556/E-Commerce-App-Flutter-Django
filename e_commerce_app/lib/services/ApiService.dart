import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/Config.dart';

class ApiService {
  static const String baseUrl = AppConfig.apiBaseUrl;
  
  final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  final _storage = const FlutterSecureStorage();

  ApiService() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle unauthorized (maybe logout)
        }
        return handler.next(e);
      }
    ));
  }

  Future<Response> login(String username, String password) async {
    return await dio.post('/users/login/', data: {
      'username': username,
      'password': password,
    });
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await dio.post('/users/register/', data: data);
  }

  Future<Response> getProducts({int? categoryId, String? search}) async {
    return await dio.get('/products/', queryParameters: {
      if (categoryId != null) 'category': categoryId,
      if (search != null) 'search': search,
    });
  }

  Future<Response> getCategories() async {
    return await dio.get('/categories/');
  }

  Future<Response> getCart() async {
    return await dio.get('/cart/');
  }

  Future<Response> updateCart(int productId, String action) async {
    return await dio.post('/cart/update/', data: {
      'productId': productId,
      'action': action,
    });
  }

  Future<Response> checkout(Map<String, dynamic> shippingData) async {
    return await dio.post('/checkout/', data: {
      'shipping': shippingData,
    });
  }

  Future<Response> getMyOrders() async {
    return await dio.get('/orders/my/');
  }

  Future<Response> getUserProfile() async {
    return await dio.get('/users/profile/');
  }

  Future<Response> verifyPassword(String password) async {
    return await dio.post('/users/verify-password/', data: {
      'password': password,
    });
  }

  Future<Response> updateProfile(Map<String, dynamic> data, {String? profilePicPath}) async {
    final formData = FormData();
    data.forEach((key, value) {
      if (value != null) formData.fields.add(MapEntry(key, value.toString()));
    });
    if (profilePicPath != null) {
      formData.files.add(MapEntry(
        'profile_pic',
        await MultipartFile.fromFile(profilePicPath, filename: profilePicPath.split('/').last),
      ));
    }
    return await dio.post('/users/update-profile/', data: formData);
  }
}
