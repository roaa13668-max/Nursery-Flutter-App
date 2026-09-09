import 'package:flutter/material.dart';
import '../models/child_model.dart';
import '../repositories/children_repository.dart';

class ChildrenProvider extends ChangeNotifier {
  final ChildrenRepository _repository = ChildrenRepository();

  List<ChildModel> _children = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<ChildModel> get children => _children;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchChildren({String? query}) async {
    _isLoading = true;
    _errorMessage = null;
    if (query != null) _searchQuery = query;
    notifyListeners();

    try {
      final response = await _repository.getChildren(searchQuery: _searchQuery);
      if (response.isSuccess && response.data != null) {
        _children = response.data!;
      } else {
        _errorMessage = response.message ?? 'تعذر جلب قائمة الأطفال';
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تحميل البيانات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchChildren(query: query);
  }

  Future<bool> addChild(ChildModel child) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.addChild(child);
      if (response.isSuccess && response.data != null) {
        // تحديث القائمة المحلية فقط عند نجاح إضافة الطفل في السيرفر
        _children.insert(0, response.data!);
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل إضافة الطفل';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء إضافة الطفل: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateChild(ChildModel child) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.updateChild(child);
      if (response.isSuccess && response.data != null) {
        final index = _children.indexWhere((c) => c.id == child.id);
        if (index != -1) {
          _children[index] = response.data!;
        }
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل تعديل بيانات الطفل';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تعديل بيانات الطفل: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteChild(int childId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.deleteChild(childId);
      if (response.isSuccess) {
        _children.removeWhere((c) => c.id == childId);
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل حذف الطفل';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء حذف الطفل: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
