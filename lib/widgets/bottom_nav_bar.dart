import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFFF80AB), width: 1.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              title: AppStrings.navHome,
              icon: Icons.home_rounded,
            ),
            _buildNavItem(
              index: 1,
              title: AppStrings.navChildren,
              icon: Icons.face_rounded,
            ),
            _buildNavItem(
              index: 2,
              title: AppStrings.navTeachers,
              icon: Icons.person_rounded,
            ),
            _buildNavItem(
              index: 3,
              title: AppStrings.navClassrooms,
              icon: Icons.more_horiz_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.navInactive;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
