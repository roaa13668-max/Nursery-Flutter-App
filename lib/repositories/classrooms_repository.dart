import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../core/api/api_response.dart';
import '../core/storage/hive_storage.dart';
import '../models/classroom_model.dart';

class ClassroomsRepository {
  final ApiClient _apiClient = ApiClient();

  static final List<ClassroomModel> _seedClassrooms = [
    ClassroomModel(
      id: 1,
      name: 'شعبة الزهرات',
      description: 'فصل المستوى التمهيدي للأطفال',
      capacity: 25,
      currentStudentsCount: 20,
      iconType: 'flower',
    ),
    ClassroomModel(
      id: 2,
      name: 'شعبة الفراشات',
      description: 'فصل الأنشطة والإبداع',
      capacity: 20,
      currentStudentsCount: 18,
      iconType: 'butterfly',
    ),
    ClassroomModel(
      id: 3,
      name: 'شعبة النجوم',
      description: 'فصل التعليم التفاعلي',
      capacity: 20,
      currentStudentsCount: 15,
      iconType: 'star',
    ),
    ClassroomModel(
      id: 4,
      name: 'شعبة الستائر',
      description: 'فصل الفنون والموسيقى',
      capacity: 20,
      currentStudentsCount: 16,
      iconType: 'bear',
    ),
    ClassroomModel(
      id: 5,
      name: 'شعبة النحل',
      description: 'فصل اللغات والاستكشاف',
      capacity: 20,
      currentStudentsCount: 17,
      iconType: 'bee',
    ),
    ClassroomModel(
      id: 6,
      name: 'شعبة الأصدقاء',
      description: 'فصل مهارات الحياة واللعب',
      capacity: 20,
      currentStudentsCount: 14,
      iconType: 'heart',
    ),
  ];

  List<ClassroomModel> _getCachedFromHive() {
    try {
      final box = HiveStorage.classroomsBox;
      if (box.isEmpty) return [];

      final List<ClassroomModel> list = [];
      for (var key in box.keys) {
        final item = box.get(key);
        if (item != null) {
          list.add(ClassroomModel.fromJson(HiveStorage.toMap(item)));
        }
      }

      list.sort((a, b) => a.id.compareTo(b.id));
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> _cacheClassroomsInHive(List<ClassroomModel> classrooms) async {
    try {
      final box = HiveStorage.classroomsBox;
      await box.clear();
      for (final classroom in classrooms) {
        await box.put(classroom.id.toString(), classroom.toJson());
      }
    } catch (_) {}
  }

  Future<ApiResponse<List<ClassroomModel>>> getClassrooms() async {
    // 1. محاولة جلب الفصول من الـ API
    try {
      final response = await _apiClient.get(ApiEndpoints.classrooms);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> list = response.data is List
            ? response.data
            : (response.data['items'] ?? response.data['data'] ?? []);
        final classrooms = list
            .map((item) => ClassroomModel.fromJson(HiveStorage.toMap(item)))
            .toList();

        await _cacheClassroomsInHive(classrooms);
        return ApiResponse.success(classrooms);
      }
    } catch (_) {
      // تجاوز أي خطأ اتصال أو Timeout
    }

    // 2. في حال فشل الاتصال أو وجود Breakpoint: قراءة الكاش المحلي من Hive
    final cached = _getCachedFromHive();
    if (cached.isNotEmpty) {
      return ApiResponse.success(cached);
    }

    // 3. ملء الكاش بالبيانات الأولية عند التشغيل لأول مرة
    await _cacheClassroomsInHive(_seedClassrooms);
    return ApiResponse.success(List.from(_seedClassrooms));
  }

  Future<ApiResponse<ClassroomModel>> addClassroom(ClassroomModel classroom) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.classrooms,
        body: classroom.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final created = ClassroomModel.fromJson(HiveStorage.toMap(response.data));
        await HiveStorage.classroomsBox.put(created.id.toString(), created.toJson());
        return ApiResponse.success(created);
      }
    } catch (_) {}

    final offlineClassroom = classroom.id == 0
        ? classroom.copyWith(id: DateTime.now().millisecondsSinceEpoch)
        : classroom;
    await HiveStorage.classroomsBox.put(offlineClassroom.id.toString(), offlineClassroom.toJson());
    return ApiResponse.success(offlineClassroom);
  }

  Future<ApiResponse<ClassroomModel>> updateClassroom(ClassroomModel classroom) async {
    await HiveStorage.classroomsBox.put(classroom.id.toString(), classroom.toJson());

    try {
      final response = await _apiClient.put(
        ApiEndpoints.classroomById(classroom.id),
        body: classroom.toJson(),
      );

      if (response.isSuccess) {
        if (response.data != null && response.data is Map) {
          final updated = ClassroomModel.fromJson(HiveStorage.toMap(response.data));
          await HiveStorage.classroomsBox.put(updated.id.toString(), updated.toJson());
          return ApiResponse.success(updated);
        }
      }
    } catch (_) {}

    return ApiResponse.success(classroom);
  }

  Future<ApiResponse<bool>> deleteClassroom(int classroomId) async {
    await HiveStorage.classroomsBox.delete(classroomId.toString());

    try {
      await _apiClient.delete(ApiEndpoints.classroomById(classroomId));
    } catch (_) {}

    return ApiResponse.success(true);
  }
}
