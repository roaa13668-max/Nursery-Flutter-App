import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../models/classroom_model.dart';
import '../../providers/classrooms_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_avatar_picker.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddClassroomScreen extends StatefulWidget {
  final ClassroomModel? classroomToEdit;

  const AddClassroomScreen({super.key, this.classroomToEdit});

  @override
  State<AddClassroomScreen> createState() => _AddClassroomScreenState();
}

class _AddClassroomScreenState extends State<AddClassroomScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _capacityController;

  bool get isEditing => widget.classroomToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.classroomToEdit?.name ?? '');
    _descController = TextEditingController(text: widget.classroomToEdit?.description ?? '');
    _capacityController = TextEditingController(
      text: widget.classroomToEdit != null ? '${widget.classroomToEdit!.capacity}' : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _saveClassroom() async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ClassroomsProvider>(context, listen: false);

      final classroom = ClassroomModel(
        id: widget.classroomToEdit?.id ?? 0,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        capacity: int.tryParse(_capacityController.text.trim()) ?? 20,
        currentStudentsCount: widget.classroomToEdit?.currentStudentsCount ?? 0,
      );

      bool success;
      if (isEditing) {
        success = await provider.updateClassroom(classroom);
      } else {
        success = await provider.addClassroom(classroom);
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'تم تعديل بيانات الفصل بنجاح' : 'تمت إضافة الفصل بنجاح'),
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
        title: isEditing ? 'تعديل بيانات الفصل' : AppStrings.addNewClassroom,
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
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.fullName,
                  hintText: AppStrings.classroomNameHint,
                  controller: _nameController,
                  validator: (val) => Validators.required(val, message: 'يرجى إدخال اسم الفصل'),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: AppStrings.description,
                  hintText: AppStrings.descriptionHint,
                  controller: _descController,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: AppStrings.capacity,
                  hintText: AppStrings.capacityHint,
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  validator: (val) => Validators.number(val, message: 'يرجى إدخال سعة صحيحة'),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: AppStrings.save,
                  onPressed: _saveClassroom,
                  isLoading: false,
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