import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/ApiService.dart';
import '../models/User.dart';
import 'package:dio/dio.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  String _parseError(dynamic e) {
    if (e is DioException) {
      if (e.response?.data != null && e.response?.data is Map) {
        final data = e.response?.data as Map;
        if (data.containsKey('detail')) return data['detail'];
        if (data.containsKey('message')) return data['message'];
        
        // Handle Django validation errors (e.g. {'username': ['Already exists']})
        final firstKey = data.keys.first;
        final firstValue = data[firstKey];
        if (firstValue is List) return '$firstKey: ${firstValue.first}';
        return data.toString();
      }
      if (e.type == DioExceptionType.connectionTimeout) return "Connection Timeout. Is server running?";
      if (e.type == DioExceptionType.receiveTimeout) return "Server is taking too long to respond.";
    }
    return e.toString();
  }

  Future<String?> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.login(username, password);
      if (response.statusCode == 200) {
        String token = response.data['access'];
        await _storage.write(key: 'access_token', value: token);
        _user = User.fromJson(response.data, token);
        _isLoading = false;
        notifyListeners();
        return null; // Success
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return _parseError(e);
    }
    _isLoading = false;
    notifyListeners();
    return "Login failed. Please try again.";
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    _user = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    String? token = await _storage.read(key: 'access_token');
    if (token != null) {
      try {
        final response = await _apiService.getUserProfile();
        if (response.statusCode == 200) {
          _user = User.fromJson(response.data, token);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('AutoLogin Error: $e');
        if (e is DioException && e.response?.statusCode == 401) {
          await logout();
        }
      }
    }
  }

  Future<bool> verifyPassword(String password) async {
    try {
      final response = await _apiService.verifyPassword(password);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Verify Password Error: $e');
      return false;
    }
  }

  Future<String?> updateProfile(Map<String, dynamic> data, {String? profilePicPath}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.updateProfile(data, profilePicPath: profilePicPath);
      if (response.statusCode == 200) {
        String? currentToken = _user?.token;
        if (currentToken != null) {
          _user = User.fromJson(response.data, currentToken);
        }
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return _parseError(e);
    }
    _isLoading = false;
    notifyListeners();
    return "Profile update failed.";
  }
}
