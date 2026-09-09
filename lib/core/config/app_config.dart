import 'package:flutter/foundation.dart';

class AppConfig {
  // Backend Base URL (ASP.NET Core Web API - NurseryManagement.API)
  // المنفذ الصحيح للـ API هو 5029 (HTTP) و 7143 (HTTPS)
  // على Web / Windows Desktop: http://localhost:5029/api
  // على محاكي أندرويد (Android Emulator): http://10.0.2.2:5029/api
  static String? _customBaseUrl;

  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }
    if (kIsWeb) {
      return 'http://localhost:5029/api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {بم
      return 'http://10.0.2.2:5029/api';
    }
    return 'http://localhost:5029/api';
  }

  static set baseUrl(String value) {
    _customBaseUrl = value;
  }

  // Request timeout duration (تم رفعها من ثانية واحدة إلى 15 ثانية لتفادي انقطاع الاتصال)
  static const Duration timeoutDuration = Duration(seconds: 15);

  // App version and metadata
  static const String appVersion = '1.0.0';
  static const String appName = 'Kindergarten Management System';

  // تعطيل الـ Offline Mocking الإجباري لضمان وصول البيانات للـ Backend
  static bool enableOfflineFallback = false;
}
