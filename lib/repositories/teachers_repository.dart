import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../core/api/api_response.dart';
import '../core/storage/hive_storage.dart';
import '../models/teacher_model.dart';

class TeachersRepository {
  final ApiClient _apiClient = ApiClient();

  static final List<TeacherModel> _seedTeachers = [
    TeacherModel(
      id: 1,
      fullName: 'أ. فاطمة علي',
      roleTitle: 'معلمة',
      sectionName: 'الزهرات',
      phone: '0501112233',
    ),
    TeacherModel(
      id: 2,
      fullName: 'أ. مريم خالد',
      roleTitle: 'معلمة',
      sectionName: 'الفراشات',
      phone: '0502223344',
    ),
    TeacherModel(
      id: 3,
      fullName: 'أ. نورة محمد',
      roleTitle: 'معلمة',
      sectionName: 'النجوم',
      phone: '0503334455',
    ),
    TeacherModel(
      id: 4,
      fullName: 'أ. سارة أحمد',
      roleTitle: 'مساعدة معلمة',
      sectionName: 'الزهرات',
      phone: '0504445566',
    ),
  ];

  List<TeacherModel> _getCachedFromHive({String? searchQuery}) {
    try {
      final box = HiveStorage.teachersBox;
      if (box.isEmpty) return [];

      final List<TeacherModel> list = [];
      for (var key in box.keys) {
        final item = box.get(key);
        if (item != null) {
          list.add(TeacherModel.fromJson(HiveStorage.toMap(item)));
        }
      }

      list.sort((a, b) => b.id.compareTo(a.id));

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        return list
            .where((t) => t.fullName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> _cacheTeachersInHive(List<TeacherModel> teachers) async {
    try {
      final box = HiveStorage.teachersBox;
      await box.clear();
      for (final teacher in teachers) {
        await box.put(teacher.id.toString(), teacher.toJson());
      }
    } catch (_) {}
  }

  Future<ApiResponse<List<TeacherModel>>> getTeachers({String? searchQuery}) async {
    // 1. محاولة جلب البيانات من الـ API
    try {
      final response = await _apiClient.get(
        ApiEndpoints.teachers,
        queryParams: searchQuery != null && searchQuery.isNotEmpty ? {'search': searchQuery} : null,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> list = response.data is List
            ? response.data
            : (response.data['items'] ?? response.data['data'] ?? []);
        final teachers = list
            .map((item) => TeacherModel.fromJson(HiveStorage.toMap(item)))
            .toList();

        await _cacheTeachersInHive(teachers);
        return ApiResponse.success(teachers);
      }
    } catch (_) {
      // تجاهل أخطاء الشبكة والانتقال لـ Hive
    }

    // 2. في حال فشل الاتصال، Timeout، أو Breakpoint: قراءة الكاش المحلي من Hive
    final cached = _getCachedFromHive(searchQuery: searchQuery);
    if (cached.isNotEmpty) {
      return ApiResponse.success(cached);
    }

    // 3. ملء الكاش بالبيانات الأولية عند التشغيل الأول
    await _cacheTeachersInHive(_seedTeachers);
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final filtered = _seedTeachers
          .where((t) => t.fullName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      return ApiResponse.success(filtered);
    }
    return ApiResponse.success(List.from(_seedTeachers));
  }

  Future<ApiResponse<TeacherModel>> addTeacher(TeacherModel teacher) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.teachers,
        body: teacher.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final created = TeacherModel.fromJson(HiveStorage.toMap(response.data));
        await HiveStorage.teachersBox.put(created.id.toString(), created.toJson());
        return ApiResponse.success(created);
      }
    } catch (_) {}

    // حفظ في Hive محلياً لضمان عدم فقدان البيانات أوفلاين
    final offlineTeacher = teacher.id == 0
        ? teacher.copyWith(id: DateTime.now().millisecondsSinceEpoch)
        : teacher;
    await HiveStorage.teachersBox.put(offlineTeacher.id.toString(), offlineTeacher.toJson());
    return ApiResponse.success(offlineTeacher);
  }

  Future<ApiResponse<TeacherModel>> updateTeacher(TeacherModel teacher) async {
    // حفظ في Hive محلياً دائماً
    await HiveStorage.teachersBox.put(teacher.id.toString(), teacher.toJson());

    try {
      final response = await _apiClient.put(
        ApiEndpoints.teacherById(teacher.id),
        body: teacher.toJson(),
      );

      if (response.isSuccess) {
        if (response.data != null && response.data is Map) {
          final updated = TeacherModel.fromJson(HiveStorage.toMap(response.data));
          await HiveStorage.teachersBox.put(updated.id.toString(), updated.toJson());
          return ApiResponse.success(updated);
        }
      }
    } catch (_) {}

    return ApiResponse.success(teacher);
  }

  Future<ApiResponse<bool>> deleteTeacher(int teacherId) async {
    await HiveStorage.teachersBox.delete(teacherId.toString());

    try {
      await _apiClient.delete(ApiEndpoints.teacherById(teacherId));
    } catch (_) {}

    return ApiResponse.success(true);
  }
}
