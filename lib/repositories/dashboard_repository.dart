import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../core/api/api_response.dart';
import '../core/config/app_config.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<DashboardSummaryModel>> getSummary() async {
    final response = await _apiClient.get(ApiEndpoints.dashboardSummary);

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(DashboardSummaryModel.fromJson(response.data));
    }

    if (AppConfig.enableOfflineFallback) {
      await Future.delayed(const Duration(milliseconds: 200));
      return ApiResponse.success(DashboardSummaryModel.initial());
    }

    return ApiResponse.error(response.message ?? 'تعذر جلب إحصائيات لوحة التحكم');
  }
}
