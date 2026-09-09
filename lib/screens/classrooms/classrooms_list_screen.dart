import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/classroom_model.dart';
import '../../providers/classrooms_provider.dart';
import '../../widgets/classroom_grid_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_error_widgets.dart';
import 'add_classroom_screen.dart';
import 'classroom_details_screen.dart';

class ClassroomsListScreen extends StatefulWidget {
  const ClassroomsListScreen({super.key});

  @override
  State<ClassroomsListScreen> createState() => _ClassroomsListScreenState();
}

class _ClassroomsListScreenState extends State<ClassroomsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClassroomsProvider>(context, listen: false).fetchClassrooms();
    });
  }

  void _confirmDeleteClassroom(ClassroomModel classroom) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف فصل "${classroom.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final provider = Provider.of<ClassroomsProvider>(context, listen: false);
              final success = await provider.deleteClassroom(classroom.id);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف الفصل بنجاح')),
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
    final classroomsProvider = Provider.of<ClassroomsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.classrooms,
        showBackButton: true,
        showAddButton: true,
        onAdd: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddClassroomScreen()),
          );
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => classroomsProvider.fetchClassrooms(),
          child: classroomsProvider.isLoading && classroomsProvider.classrooms.isEmpty
              ? const LoadingWidget(message: 'جاري تحميل قائمة الفصول...')
              : classroomsProvider.errorMessage != null && classroomsProvider.classrooms.isEmpty
                  ? ErrorRetryWidget(
                      message: classroomsProvider.errorMessage!,
                      onRetry: () => classroomsProvider.fetchClassrooms(),
                    )
                  : classroomsProvider.classrooms.isEmpty
                      ? const EmptyDataWidget(message: 'لا توجد فصول مسجلة حالياً')
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: classroomsProvider.classrooms.length,
                          itemBuilder: (context, index) {
                            final classroom = classroomsProvider.classrooms[index];
                            return ClassroomGridCard(
                              classroom: classroom,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ClassroomDetailsScreen(classroom: classroom),
                                  ),
                                );
                              },
                              onDelete: () => _confirmDeleteClassroom(classroom),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
