// lib/viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _apiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    isLoading = false;

    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result['message'] ?? 'Login failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _apiService.post('/auth/signup', {
      'name': name,
      'email': email,
      'password': password,
    });

    isLoading = false;

    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      errorMessage = result['message'] ?? 'Sign up failed';
      notifyListeners();
      return false;
    }
  }
}
