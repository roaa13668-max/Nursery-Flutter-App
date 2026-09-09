import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_response.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  String? get authToken => _authToken;

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<ApiResponse<dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      var uri = Uri.parse('${AppConfig.baseUrl}$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(AppConfig.timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('انتهت مهلة الاتصال بالخادم');
    } on http.ClientException catch (e) {
      return ApiResponse.error('تعذر الاتصال بالخادم، يرجى التأكد من تشغيل الـ API: ${e.message}');
    } catch (e) {
      return ApiResponse.error('حدث خطأ غير متوقع: $e');
    }
  }

  Future<ApiResponse<dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}$endpoint');
      final response = await http
          .post(
            uri,
            headers: _getHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('انتهت مهلة الاتصال بالخادم');
    } on http.ClientException catch (e) {
      return ApiResponse.error('تعذر الاتصال بالخادم، يرجى التأكد من تشغيل الـ API: ${e.message}');
    } catch (e) {
      return ApiResponse.error('حدث خطأ أثناء إرسال البيانات: $e');
    }
  }

  Future<ApiResponse<dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}$endpoint');
      final response = await http
          .put(
            uri,
            headers: _getHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('انتهت مهلة الاتصال بالخادم');
    } on http.ClientException catch (e) {
      return ApiResponse.error('تعذر الاتصال بالخادم، يرجى التأكد من تشغيل الـ API: ${e.message}');
    } catch (e) {
      return ApiResponse.error('حدث خطأ أثناء تعديل البيانات: $e');
    }
  }

  Future<ApiResponse<dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}$endpoint');
      final response = await http
          .delete(uri, headers: _getHeaders())
          .timeout(AppConfig.timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('انتهت مهلة الاتصال بالخادم');
    } on http.ClientException catch (e) {
      return ApiResponse.error('تعذر الاتصال بالخادم، يرجى التأكد من تشغيل الـ API: ${e.message}');
    } catch (e) {
      return ApiResponse.error('حدث خطأ أثناء الحذف: $e');
    }
  }

  ApiResponse<dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic responseBody;

    try {
      if (response.body.isNotEmpty) {
        responseBody = jsonDecode(response.body);
      }
    } catch (_) {
      responseBody = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse.success(responseBody, statusCode: statusCode);
    } else if (statusCode == 401) {
      return ApiResponse.error('غير مصرح، يرجى تسجيل الدخول مجدداً', statusCode: 401);
    } else if (statusCode == 403) {
      return ApiResponse.error('ليس لديك الصلاحية للوصول', statusCode: 403);
    } else if (statusCode == 404) {
      return ApiResponse.error('العنصر المطلوب غير موجود', statusCode: 404);
    } else if (statusCode >= 500) {
      return ApiResponse.error('خطأ في خادم النظام ($statusCode)', statusCode: statusCode);
    } else {
      String msg = 'حدث خطأ في الطلب ($statusCode)';
      if (responseBody is Map && responseBody['message'] != null) {
        msg = responseBody['message'].toString();
      }
      return ApiResponse.error(msg, statusCode: statusCode);
    }
  }
}
