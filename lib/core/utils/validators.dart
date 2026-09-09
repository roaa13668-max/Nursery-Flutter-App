class Validators {
  static String? required(String? value, {String message = 'هذا الحقل مطلوب'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
    }
    return null;
  }

  static String? number(String? value, {String message = 'يرجى إدخال رقم صحيح'}) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    if (int.tryParse(value.trim()) == null) {
      return message;
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    if (value.trim().length < 8) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }
}
