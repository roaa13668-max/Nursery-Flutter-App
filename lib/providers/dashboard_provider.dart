import 'package:flutter/material.dart';
import '../models/dashboard_summary_model.dart';
import '../repositories/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  DashboardSummaryModel _summary = DashboardSummaryModel.initial();
  bool _isLoading = false;
  String? _errorMessage;

  DashboardSummaryModel get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSummary() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getSummary();
    _isLoading = false;

    if (response.isSuccess && response.data != null) {
      _summary = response.data!;
    } else {
      _errorMessage = response.message;
    }
    notifyListeners();
  }
}
