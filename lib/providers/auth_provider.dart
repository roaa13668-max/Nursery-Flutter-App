import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.login(email, password);
    _isLoading = false;

    if (response.isSuccess && response.data != null) {
      _currentUser = response.data;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message ?? 'فشل تسجيل الدخول';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _repository.logout();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
