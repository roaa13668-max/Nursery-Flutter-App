import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/child_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_illustrations.dart';
import 'add_child_screen.dart';

class ChildDetailsScreen extends StatelessWidget {
  final ChildModel child;

  const ChildDetailsScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'تفاصيل الطفل',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CustomAvatarWidget(
                name: child.fullName,
                gender: child.gender,
                size: 90,
              ),
              const SizedBox(height: 16),

              Text(
                child.fullName,
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
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'الشعبة: ${child.sectionName}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Info Cards
              _buildInfoRow(Icons.cake_rounded, 'العمر', '${child.age} سنوات'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.wc_rounded, 'الجنس', child.gender),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone_rounded, 'رقم ولي الأمر', child.parentPhone.isNotEmpty ? child.parentPhone : '0501234567'),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.meeting_room_rounded, 'الفصل', 'شعبة ${child.sectionName}'),
              const SizedBox(height: 40),

              // Edit Button
              CustomButton(
                text: 'تعديل البيانات',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AddChildScreen(childToEdit: child)),
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
