import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/teacher_model.dart';
import '../../providers/teachers_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_error_widgets.dart';
import '../../widgets/teacher_list_item.dart';
import 'add_teacher_screen.dart';
import 'teacher_details_screen.dart';

class TeachersListScreen extends StatefulWidget {
  const TeachersListScreen({super.key});

  @override
  State<TeachersListScreen> createState() => _TeachersListScreenState();
}

class _TeachersListScreenState extends State<TeachersListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeachersProvider>(context, listen: false).fetchTeachers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDeleteTeacher(TeacherModel teacher) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المعلم "${teacher.fullName}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final provider = Provider.of<TeachersProvider>(context, listen: false);
              final success = await provider.deleteTeacher(teacher.id);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف المعلم بنجاح')),
                );
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teachersProvider = Provider.of<TeachersProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.teachers,
        showBackButton: true,
        showAddButton: true,
        onAdd: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTeacherScreen()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar matching screenshot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => teachersProvider.setSearchQuery(val),
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintText: AppStrings.searchTeacherHint,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: Icon(Icons.search, color: Colors.black87),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: false,
                  ),
                ),
              ),
            ),

            // Teachers List
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => teachersProvider.fetchTeachers(),
                child: teachersProvider.isLoading && teachersProvider.teachers.isEmpty
                    ? const LoadingWidget(message: 'جاري تحميل قائمة المعلمين...')
                    : teachersProvider.errorMessage != null && teachersProvider.teachers.isEmpty
                        ? ErrorRetryWidget(
                            message: teachersProvider.errorMessage!,
                            onRetry: () => teachersProvider.fetchTeachers(),
                          )
                        : teachersProvider.teachers.isEmpty
                            ? const EmptyDataWidget(message: 'لا يوجد معلمون مسجلون حالياً')
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: teachersProvider.teachers.length,
                                itemBuilder: (context, index) {
                                  final teacher = teachersProvider.teachers[index];
                                  return TeacherListItem(
                                    teacher: teacher,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => TeacherDetailsScreen(teacher: teacher),
                                        ),
                                      );
                                    },
                                    onEdit: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AddTeacherScreen(teacherToEdit: teacher),
                                        ),
                                      );
                                    },
                                    onDelete: () => _confirmDeleteTeacher(teacher),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
