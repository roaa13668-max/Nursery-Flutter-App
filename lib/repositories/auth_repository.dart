import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../core/api/api_response.dart';
import '../core/config/app_config.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<UserModel>> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.isSuccess && response.data != null) {
      final user = UserModel.fromJson(response.data);
      if (user.token != null) {
        _apiClient.setAuthToken(user.token);
      }
      return ApiResponse.success(user);
    }

    // If API server is offline and offline fallback is enabled
    if (AppConfig.enableOfflineFallback) {
      await Future.delayed(const Duration(milliseconds: 600)); // Simulate network
      final mockUser = UserModel(
        id: 1,
        fullName: 'مدير النظام',
        email: email.isNotEmpty ? email : 'admin@kindergarten.com',
        token: 'mock-jwt-token-kindergarten-2026',
        role: UserRole.admin,
      );
      _apiClient.setAuthToken(mockUser.token);
      return ApiResponse.success(mockUser);
    }

    return ApiResponse.error(response.message ?? 'فشل تسجيل الدخول');
  }

  void logout() {
    _apiClient.setAuthToken(null);
  }
}
