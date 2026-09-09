enum UserRole { admin, teacher, parent }

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? token;
  final UserRole role;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.token,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserRole parsedRole = UserRole.admin;
    final roleStr = (json['role'] ?? json['userRole'] ?? 'admin').toString().toLowerCase();
    if (roleStr.contains('teacher') || roleStr.contains('معلم')) {
      parsedRole = UserRole.teacher;
    } else if (roleStr.contains('parent') || roleStr.contains('ولي')) {
      parsedRole = UserRole.parent;
    }

    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 1,
      fullName: json['fullName'] ?? json['name'] ?? 'مستخدم النظام',
      email: json['email'] ?? '',
      token: json['token'] ?? json['jwt'] ?? json['accessToken'],
      role: parsedRole,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'token': token,
      'role': role.name,
    };
  }
}
