import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const String childrenBox = 'childrenBox';
  static const String teachersBox = 'teachersBox';
  static const String classroomsBox = 'classroomsBox';
}

class HiveStorage {
  static Box get childrenBox => Hive.box(HiveBoxes.childrenBox);
  static Box get teachersBox => Hive.box(HiveBoxes.teachersBox);
  static Box get classroomsBox => Hive.box(HiveBoxes.classroomsBox);

  /// Safe conversion from dynamic Hive map to `Map<String, dynamic>`
  static Map<String, dynamic> toMap(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return {};
  }
}
