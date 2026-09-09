class TeacherModel {
  final int id;
  final String fullName;
  final String roleTitle; // 'معلمة' or 'مساعدة معلمة' - مطابقة مع Specialization في الـ Backend
  final String sectionName; // 'الزهرات', 'الفراشات', 'النجوم'
  final String phone; // مطابقة مع PhoneNumber في الـ Backend
  final double salary;
  final String? avatarUrl;

  TeacherModel({
    required this.id,
    required this.fullName,
    required this.roleTitle,
    required this.sectionName,
    required this.phone,
    this.salary = 0.0,
    this.avatarUrl,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName: (json['fullName'] ?? json['FullName'] ?? json['name'] ?? json['Name'] ?? '').toString(),
      roleTitle: (json['specialization'] ?? json['Specialization'] ?? json['roleTitle'] ?? json['RoleTitle'] ?? json['title'] ?? json['Title'] ?? 'معلمة').toString(),
      sectionName: (json['sectionName'] ?? json['SectionName'] ?? json['classroomName'] ?? json['ClassroomName'] ?? 'الزهرات').toString(),
      phone: (json['phoneNumber'] ?? json['PhoneNumber'] ?? json['phone'] ?? json['Phone'] ?? '').toString(),
      salary: (json['salary'] ?? json['Salary'] ?? 0) is num
          ? (json['salary'] ?? json['Salary'] ?? 0).toDouble()
          : double.tryParse((json['salary'] ?? json['Salary'] ?? '0').toString()) ?? 0.0,
      avatarUrl: json['avatarUrl'] ?? json['AvatarUrl'] ?? json['imageUrl'] ?? json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'specialization': roleTitle, // مطابقة كيان C#
      'roleTitle': roleTitle,
      'phoneNumber': phone, // مطابقة كيان C#
      'phone': phone,
      'salary': salary,
      'sectionName': sectionName,
      'avatarUrl': avatarUrl,
    };
  }

  TeacherModel copyWith({
    int? id,
    String? fullName,
    String? roleTitle,
    String? sectionName,
    String? phone,
    double? salary,
    String? avatarUrl,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      roleTitle: roleTitle ?? this.roleTitle,
      sectionName: sectionName ?? this.sectionName,
      phone: phone ?? this.phone,
      salary: salary ?? this.salary,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
