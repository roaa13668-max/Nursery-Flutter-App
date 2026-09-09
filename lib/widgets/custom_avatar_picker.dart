import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomAvatarPicker extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const CustomAvatarPicker({
    super.key,
    this.onTap,
    this.size = 105,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم اختيار صورة تجريبية بنجاح'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFD1DF),
            border: Border.all(color: const Color(0xFFFF80AB), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1AE83181),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: size * 0.65,
              height: size * 0.65,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
