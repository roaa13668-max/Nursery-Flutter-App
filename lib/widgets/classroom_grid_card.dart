import 'package:flutter/material.dart';
import '../models/classroom_model.dart';
import 'custom_illustrations.dart';

class ClassroomGridCard extends StatelessWidget {
  final ClassroomModel classroom;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ClassroomGridCard({
    super.key,
    required this.classroom,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClassroomIconWidget(
              iconType: classroom.iconType,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              classroom.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'طفل ${classroom.currentStudentsCount}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
