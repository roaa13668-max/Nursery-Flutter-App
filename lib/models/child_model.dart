class ChildModel {
  final int id;
  final String fullName;
  final int age;
  final String? parentName;
  final String gender; // 'ذكر' or 'انثى' / 'male' or 'female'
  final String sectionName; // e.g. "الزهرات"
  final String parentPhone;
  final String? avatarUrl;
  final int? classroomId;

  ChildModel({
    required this.id,
    required this.fullName,
    required this.age,
    this.parentName,
    required this.gender,
    required this.sectionName,
    required this.parentPhone,
    this.avatarUrl,
    this.classroomId,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName: (json['fullName'] ?? json['FullName'] ?? json['name'] ?? json['Name'] ?? '').toString(),
      age: json['age'] is int ? json['age'] : int.tryParse(json['age']?.toString() ?? '4') ?? 4,
      parentName: (json['parentName'] ?? json['ParentName'] ?? '').toString(),
      gender: (json['gender'] ?? json['Gender'] ?? 'ذكر').toString(),
      sectionName: (json['sectionName'] ?? json['SectionName'] ?? json['classroomName'] ?? json['ClassroomName'] ?? 'الزهرات').toString(),
      parentPhone: (json['phoneNumber'] ?? json['PhoneNumber'] ?? json['parentPhone'] ?? json['ParentPhone'] ?? json['phone'] ?? json['Phone'] ?? '').toString(),
      avatarUrl: json['avatarUrl'] ?? json['AvatarUrl'] ?? json['imageUrl'] ?? json['ImageUrl'],
      classroomId: json['classroomId'] is int ? json['classroomId'] : int.tryParse(json['classroomId']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'age': age,
      'parentName': parentName ?? '',
      'phoneNumber': parentPhone, // مطابقة كيان C#
      'parentPhone': parentPhone,
      'gender': gender,
      'sectionName': sectionName,
      'avatarUrl': avatarUrl,
      'classroomId': classroomId,
    };
  }

  ChildModel copyWith({
    int? id,
    String? fullName,
    int? age,
    String? parentName,
    String? gender,
    String? sectionName,
    String? parentPhone,
    String? avatarUrl,
    int? classroomId,
  }) {
    return ChildModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      parentName: parentName ?? this.parentName,
      gender: gender ?? this.gender,
      sectionName: sectionName ?? this.sectionName,
      parentPhone: parentPhone ?? this.parentPhone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      classroomId: classroomId ?? this.classroomId,
    );
  }
}
