import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/child_model.dart';
import '../../providers/children_provider.dart';

class AddChildScreen extends StatefulWidget {
  final ChildModel? childToEdit;

  const AddChildScreen({super.key, this.childToEdit});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneController;
  late final TextEditingController _sectionController;
  late String _selectedGender;

  bool get isEditing => widget.childToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.childToEdit?.fullName ?? '');
    _ageController = TextEditingController(
      text: widget.childToEdit != null ? '${widget.childToEdit!.age}' : '',
    );
    _phoneController = TextEditingController(text: widget.childToEdit?.parentPhone ?? '');
    _sectionController = TextEditingController(text: widget.childToEdit?.sectionName ?? '');
    _selectedGender = widget.childToEdit?.gender ?? 'ذكر';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'تعديل بيانات الطفل' : 'إضافة طفل جديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'العمر'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final childData = ChildModel(
                        id: widget.childToEdit?.id ?? 0, // 0 ليتولى السيرفر والـ SQLite الترقيم التلقائي
                        fullName: _nameController.text.trim(),
                        age: int.tryParse(_ageController.text.trim()) ?? 5,
                        gender: _selectedGender,
                        sectionName: _sectionController.text.trim().isEmpty 
                            ? 'أ' 
                            : _sectionController.text.trim(),
                        parentPhone: _phoneController.text.trim(),
                      );

                      final provider = Provider.of<ChildrenProvider>(context, listen: false);
                      bool success;
                      if (isEditing) {
                        success = await provider.updateChild(childData);
                      } else {
                        success = await provider.addChild(childData);
                      }

                      if (context.mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isEditing ? 'تم تعديل بيانات الطفل بنجاح' : 'تمت إضافة الطفل بنجاح'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(provider.errorMessage ?? 'حدث خطأ أثناء حفظ البيانات'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(isEditing ? 'حفظ التعديلات' : 'حفظ', style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}