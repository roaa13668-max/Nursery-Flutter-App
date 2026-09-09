import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../core/api/api_response.dart';
import '../core/storage/hive_storage.dart';
import '../models/child_model.dart';

class ChildrenRepository {
  final ApiClient _apiClient = ApiClient();

  // البيانات الافتراضية الأولية في حال كان التخزين المحلي فارغاً تماماً
  static final List<ChildModel> _seedChildren = [
    ChildModel(
      id: 1,
      fullName: 'أحمد محمد',
      age: 4,
      gender: 'ذكر',
      sectionName: 'الزهرات',
      parentPhone: '0501234567',
    ),
    ChildModel(
      id: 2,
      fullName: 'سارة علي',
      age: 4,
      gender: 'انثى',
      sectionName: 'الزهرات',
      parentPhone: '0509876543',
    ),
    ChildModel(
      id: 3,
      fullName: 'لينا حسن',
      age: 4,
      gender: 'انثى',
      sectionName: 'الزهرات',
      parentPhone: '0551122334',
    ),
    ChildModel(
      id: 4,
      fullName: 'يوسف خالد',
      age: 4,
      gender: 'ذكر',
      sectionName: 'الزهرات',
      parentPhone: '0569988776',
    ),
  ];

  /// جلب البيانات من الكاش المحلي Hive
  List<ChildModel> _getCachedFromHive({String? searchQuery}) {
    try {
      final box = HiveStorage.childrenBox;
      if (box.isEmpty) return [];

      final List<ChildModel> list = [];
      for (var key in box.keys) {
        final item = box.get(key);
        if (item != null) {
          list.add(ChildModel.fromJson(HiveStorage.toMap(item)));
        }
      }

      // ترتيب تنازلي حسب المعرّف
      list.sort((a, b) => b.id.compareTo(a.id));

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        return list
            .where((c) => c.fullName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  /// حفظ البيانات في الكاش المحلي Hive
  Future<void> _cacheChildrenInHive(List<ChildModel> children) async {
    try {
      final box = HiveStorage.childrenBox;
      await box.clear();
      for (final child in children) {
        await box.put(child.id.toString(), child.toJson());
      }
    } catch (_) {}
  }

  Future<ApiResponse<List<ChildModel>>> getChildren({String? searchQuery}) async {
    // 1. محاولة جلب البيانات من الـ API
    try {
      final response = await _apiClient.get(
        ApiEndpoints.children,
        queryParams: searchQuery != null && searchQuery.isNotEmpty ? {'search': searchQuery} : null,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> list = response.data is List
            ? response.data
            : (response.data['items'] ?? response.data['data'] ?? []);
        final children = list
            .map((item) => ChildModel.fromJson(HiveStorage.toMap(item)))
            .toList();

        // تحديث الكاش المحلي في Hive فوراً
        await _cacheChildrenInHive(children);
        return ApiResponse.success(children);
      }
    } catch (_) {
      // تجاهل أخطاء الشبكة أو التايم آوت والانتقال فوراً لـ Hive
    }

    // 2. في حال فشل الاتصال، أو وجود Timeout، أو إيقاف الـ API (Breakpoint):
    // قراءة البيانات فوراً وبسلاسة من Hive Local Storage
    final cached = _getCachedFromHive(searchQuery: searchQuery);
    if (cached.isNotEmpty) {
      return ApiResponse.success(cached);
    }

    // 3. إذا كان التخزين المحلي فارغاً لأول مرة: ملء الكاش بالبيانات الأولية
    await _cacheChildrenInHive(_seedChildren);
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final filtered = _seedChildren
          .where((c) => c.fullName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      return ApiResponse.success(filtered);
    }
    return ApiResponse.success(List.from(_seedChildren));
  }

  Future<ApiResponse<ChildModel>> addChild(ChildModel child) async {
    // 1. محاولة إرسال البيانات للـ Backend API
    try {
      final response = await _apiClient.post(
        ApiEndpoints.children,
        body: child.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final createdChild = ChildModel.fromJson(HiveStorage.toMap(response.data));
        // حفظ في Hive محلياً بالمعرف الفعلي الصادر من السيرفر
        await HiveStorage.childrenBox.put(createdChild.id.toString(), createdChild.toJson());
        return ApiResponse.success(createdChild);
      }
    } catch (_) {
      // استكمال الحفظ المحلي عند انقطاع الاتصال
    }

    // 2. إذا كان السيرفر غير متصل أو حدث Timeout: حفظ محلياً في Hive لضمان بقاء البيانات
    final offlineChild = child.id == 0
        ? child.copyWith(id: DateTime.now().millisecondsSinceEpoch)
        : child;
    await HiveStorage.childrenBox.put(offlineChild.id.toString(), offlineChild.toJson());
    return ApiResponse.success(offlineChild);
  }

  Future<ApiResponse<ChildModel>> updateChild(ChildModel child) async {
    // حفظ التعديل محلياً في Hive دائماً لضمان بقاء التحديث
    await HiveStorage.childrenBox.put(child.id.toString(), child.toJson());

    try {
      final response = await _apiClient.put(
        ApiEndpoints.childById(child.id),
        body: child.toJson(),
      );

      if (response.isSuccess) {
        if (response.data != null && response.data is Map) {
          final updated = ChildModel.fromJson(HiveStorage.toMap(response.data));
          await HiveStorage.childrenBox.put(updated.id.toString(), updated.toJson());
          return ApiResponse.success(updated);
        }
      }
    } catch (_) {
      // في حالة انقطاع الشبكة، تم التعديل محلياً في Hive بالفعل
    }

    return ApiResponse.success(child);
  }

  Future<ApiResponse<bool>> deleteChild(int childId) async {
    // حذف العنصر محلياً من Hive دائماً
    await HiveStorage.childrenBox.delete(childId.toString());

    try {
      await _apiClient.delete(ApiEndpoints.childById(childId));
    } catch (_) {
      // تم الحذف محلياً
    }

    return ApiResponse.success(true);
  }
}
