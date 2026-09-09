import 'package:flutter/material.dart';
import '../models/teacher_model.dart';
import '../repositories/teachers_repository.dart';

class TeachersProvider extends ChangeNotifier {
  final TeachersRepository _repository = TeachersRepository();

  List<TeacherModel> _teachers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<TeacherModel> get teachers => _teachers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchTeachers({String? query}) async {
    _isLoading = true;
    _errorMessage = null;
    if (query != null) _searchQuery = query;
    notifyListeners();

    try {
      final response = await _repository.getTeachers(searchQuery: _searchQuery);
      if (response.isSuccess && response.data != null) {
        _teachers = response.data!;
      } else {
        _errorMessage = response.message ?? 'تعذر جلب قائمة المعلمين';
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
    fetchTeachers(query: query);
  }

  Future<bool> addTeacher(TeacherModel teacher) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.addTeacher(teacher);
      if (response.isSuccess && response.data != null) {
        // تحديث القائمة المحلية فقط عند نجاح إضافة المعلم في السيرفر
        _teachers.insert(0, response.data!);
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل إضافة المعلم';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء إضافة المعلم: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTeacher(TeacherModel teacher) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.updateTeacher(teacher);
      if (response.isSuccess && response.data != null) {
        final index = _teachers.indexWhere((t) => t.id == teacher.id);
        if (index != -1) {
          _teachers[index] = response.data!;
        }
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل تعديل بيانات المعلم';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تعديل بيانات المعلم: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTeacher(int teacherId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.deleteTeacher(teacherId);
      if (response.isSuccess) {
        _teachers.removeWhere((t) => t.id == teacherId);
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل حذف المعلم';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء حذف المعلم: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
