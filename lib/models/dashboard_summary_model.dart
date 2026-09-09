class DashboardSummaryModel {
  final int childrenCount;
  final int teachersCount;
  final int todayAttendance;
  final int parentsCount;

  DashboardSummaryModel({
    required this.childrenCount,
    required this.teachersCount,
    required this.todayAttendance,
    required this.parentsCount,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      childrenCount: json['childrenCount'] is int
          ? json['childrenCount']
          : int.tryParse(json['childrenCount']?.toString() ?? '32') ?? 32,
      teachersCount: json['teachersCount'] is int
          ? json['teachersCount']
          : int.tryParse(json['teachersCount']?.toString() ?? '12') ?? 12,
      todayAttendance: json['todayAttendance'] is int
          ? json['todayAttendance']
          : int.tryParse(json['todayAttendance']?.toString() ?? '26') ?? 26,
      parentsCount: json['parentsCount'] is int
          ? json['parentsCount']
          : int.tryParse(json['parentsCount']?.toString() ?? '28') ?? 28,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childrenCount': childrenCount,
      'teachersCount': teachersCount,
      'todayAttendance': todayAttendance,
      'parentsCount': parentsCount,
    };
  }

  static DashboardSummaryModel initial() {
    return DashboardSummaryModel(
      childrenCount: 32,
      teachersCount: 12,
      todayAttendance: 26,
      parentsCount: 28,
    );
  }
}
