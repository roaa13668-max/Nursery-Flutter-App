import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/teacher_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_illustrations.dart';
import 'add_teacher_screen.dart';

class TeacherDetailsScreen extends StatelessWidget {
  final TeacherModel teacher;

  const TeacherDetailsScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'تفاصيل المعلم',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAvatarWidget(
                name: teacher.fullName,
                gender: 'انثى',
                size: 90,
              ),
              const SizedBox(height: 16),

              Text(
                teacher.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statTeachersBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  teacher.roleTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              _buildInfoRow(Icons.person_pin_rounded, 'الدور الوظيفي', teacher.roleTitle),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.meeting_room_rounded, 'الشعبة المسؤولة', 'شعبة ${teacher.sectionName}'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone_rounded, 'رقم الهاتف', teacher.phone.isNotEmpty ? teacher.phone : '0501112233'),
              const SizedBox(height: 40),

              CustomButton(
                text: 'تعديل البيانات',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AddTeacherScreen(teacherToEdit: teacher)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
