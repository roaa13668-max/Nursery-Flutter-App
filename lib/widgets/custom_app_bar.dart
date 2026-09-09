import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool showAddButton;
  final VoidCallback? onAdd;
  final Widget? customTrailing;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.showAddButton = false,
    this.onAdd,
    this.customTrailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pink top accent notch bar
        Container(
          height: 6,
          width: 140,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                )
              : const SizedBox.shrink(),
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            if (showAddButton)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33E83181),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 26),
                  ),
                ),
              ),
            if (customTrailing != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: customTrailing!,
              ),
          ],
        ),
      ],
    );
  }
}
