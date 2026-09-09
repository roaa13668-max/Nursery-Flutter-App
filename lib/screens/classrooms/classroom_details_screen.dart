import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/classroom_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_illustrations.dart';
import 'add_classroom_screen.dart';

class ClassroomDetailsScreen extends StatelessWidget {
  final ClassroomModel classroom;

  const ClassroomDetailsScreen({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'تفاصيل الفصل',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClassroomIconWidget(
                iconType: classroom.iconType,
                size: 90,
              ),
              const SizedBox(height: 16),

              Text(
                classroom.name,
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
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'عدد الأطفال: ${classroom.currentStudentsCount} / ${classroom.capacity}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8E24AA),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              _buildInfoRow(Icons.description_outlined, 'الوصف', classroom.description ?? 'فصل تعليمي للأطفال'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.group_rounded, 'السعة الاستيعابية', '${classroom.capacity} طفل'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.check_circle_outline_rounded, 'الأطفال الحاليين', '${classroom.currentStudentsCount} طفل'),
              const SizedBox(height: 40),

              CustomButton(
                text: 'تعديل البيانات',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AddClassroomScreen(classroomToEdit: classroom)),
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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
