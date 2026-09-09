import 'package:flutter/material.dart';
import '../models/classroom_model.dart';
import '../repositories/classrooms_repository.dart';

class ClassroomsProvider extends ChangeNotifier {
  final ClassroomsRepository _repository = ClassroomsRepository();

  List<ClassroomModel> _classrooms = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ClassroomModel> get classrooms => _classrooms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchClassrooms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getClassrooms();
      if (response.isSuccess && response.data != null) {
        _classrooms = response.data!;
      } else {
        _errorMessage = response.message ?? 'تعذر جلب قائمة الفصول';
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تحميل الفصول: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addClassroom(ClassroomModel classroom) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.addClassroom(classroom);
      if (response.isSuccess && response.data != null) {
        // تحديث القائمة المحلية فقط عند نجاح إضافة الفصل في السيرفر
        _classrooms.insert(0, response.data!);
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل إضافة الفصل';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء إضافة الفصل: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateClassroom(ClassroomModel classroom) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.updateClassroom(classroom);
      if (response.isSuccess && response.data != null) {
        final index = _classrooms.indexWhere((c) => c.id == classroom.id);
        if (index != -1) {
          _classrooms[index] = response.data!;
        }
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل تعديل بيانات الفصل';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تعديل الفصل: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteClassroom(int classroomId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.deleteClassroom(classroomId);
      if (response.isSuccess) {
        _classrooms.removeWhere((c) => c.id == classroomId);
        return true;
      } else {
        _errorMessage = response.message ?? 'فشل حذف الفصل';
        return false;
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء حذف الفصل: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
