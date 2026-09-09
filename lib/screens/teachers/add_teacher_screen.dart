import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../models/teacher_model.dart';
import '../../providers/teachers_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_avatar_picker.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddTeacherScreen extends StatefulWidget {
  final TeacherModel? teacherToEdit;

  const AddTeacherScreen({super.key, this.teacherToEdit});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  bool get isEditing => widget.teacherToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacherToEdit?.fullName ?? '');
    _phoneController = TextEditingController(text: widget.teacherToEdit?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveTeacher() async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<TeachersProvider>(context, listen: false);

      final teacher = TeacherModel(
        id: widget.teacherToEdit?.id ?? 0,
        fullName: _nameController.text.trim(),
        roleTitle: widget.teacherToEdit?.roleTitle ?? AppStrings.teacherRole,
        sectionName: widget.teacherToEdit?.sectionName ?? 'الزهرات',
        phone: _phoneController.text.trim(),
      );

      bool success;
      if (isEditing) {
        success = await provider.updateTeacher(teacher);
      } else {
        success = await provider.addTeacher(teacher);
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'تم تعديل بيانات المعلم بنجاح' : 'تمت إضافة المعلم بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? AppStrings.errorOccurred),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: isEditing ? 'تعديل بيانات المعلم' : AppStrings.addNewTeacher,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const CustomAvatarPicker(),
                const SizedBox(height: 16), // تقليل المسافة لتجنب الـ Overflow
                CustomTextField(
                  label: AppStrings.fullName,
                  hintText: 'ادخل اسم المعلم',
                  controller: _nameController,
                  validator: (val) => Validators.required(val, message: 'يرجى إدخال اسم المعلم'),
                ),
                const SizedBox(height: 12), // تقليل المسافة
                CustomTextField(
                  label: AppStrings.phoneNumber,
                  hintText: AppStrings.phoneHint,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 20), // تقليل المسافة
                CustomButton(
                  text: AppStrings.save,
                  onPressed: _saveTeacher,
                  isLoading: false, // تحويلها لـ false مؤقتاً لضمان عدم التعليق
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}