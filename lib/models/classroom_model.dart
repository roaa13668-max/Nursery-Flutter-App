class ClassroomModel {
  final int id;
  final String name; // e.g. "شعبة الزهرات" - مطابقة مع ClassName في الـ Backend
  final String? description;
  final int capacity;
  final int currentStudentsCount;
  final String iconType; // 'flower', 'butterfly', 'star', 'bear', 'bee', 'heart'

  ClassroomModel({
    required this.id,
    required this.name,
    this.description,
    required this.capacity,
    required this.currentStudentsCount,
    this.iconType = 'flower',
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['className'] ?? json['ClassName'] ?? json['name'] ?? json['Name'] ?? '').toString(),
      description: (json['description'] ?? json['Description'])?.toString(),
      capacity: json['capacity'] is int ? json['capacity'] : int.tryParse(json['capacity']?.toString() ?? '20') ?? 20,
      currentStudentsCount: json['currentStudentsCount'] is int
          ? json['currentStudentsCount']
          : int.tryParse(json['currentStudentsCount']?.toString() ?? json['studentCount']?.toString() ?? '0') ?? 0,
      iconType: (json['iconType'] ?? json['IconType'] ?? _determineIconByName(json['className'] ?? json['ClassName'] ?? json['name'] ?? '')).toString(),
    );
  }

  static String _determineIconByName(String name) {
    if (name.contains('زهر')) return 'flower';
    if (name.contains('فراش')) return 'butterfly';
    if (name.contains('نجم') || name.contains('نجوم')) return 'star';
    if (name.contains('ستائر') || name.contains('دب') || name.contains('سنافر')) return 'bear';
    if (name.contains('نحل')) return 'bee';
    if (name.contains('أصدقاء') || name.contains('قلب')) return 'heart';
    return 'flower';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': name, // مطابقة كيان C# ClassName
      'name': name,
      'description': description ?? '',
      'capacity': capacity,
      'currentStudentsCount': currentStudentsCount,
      'iconType': iconType,
    };
  }

  ClassroomModel copyWith({
    int? id,
    String? name,
    String? description,
    int? capacity,
    int? currentStudentsCount,
    String? iconType,
  }) {
    return ClassroomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      capacity: capacity ?? this.capacity,
      currentStudentsCount: currentStudentsCount ?? this.currentStudentsCount,
      iconType: iconType ?? this.iconType,
    );
  }
}
