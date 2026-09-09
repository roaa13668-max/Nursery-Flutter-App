import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Renders a cute 5-point star
class StarWidget extends StatelessWidget {
  final double size;
  final Color color;

  const StarWidget({
    super.key,
    this.size = 28,
    this.color = AppColors.starYellow,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarPainter(color),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.45;
    const int points = 5;
    final double step = math.pi / points;

    for (int i = 0; i < 2 * points; i++) {
      final r = (i % 2 == 0) ? outerRadius : innerRadius;
      final angle = i * step - math.pi / 2;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Circular Kindergarten School Illustration matching Splash Screen
class KindergartenIllustrationWidget extends StatelessWidget {
  final double size;
  const KindergartenIllustrationWidget({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFF0F5),
        border: Border.all(color: const Color(0xFFFFD1E3), width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1AE83181),
            blurRadius: 15,
            spreadRadius: 3,
          )
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // School Roof & Building
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flag / Chimney
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 18,
                      color: const Color(0xFFD32F2F),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 14,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB300),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3),
                          bottomRight: Radius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                // Roof
                CustomPaint(
                  size: Size(size * 0.55, size * 0.22),
                  painter: _RoofPainter(),
                ),
                // House Body
                Container(
                  width: size * 0.5,
                  height: size * 0.35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECB3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFB74D), width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Windows
                      Positioned(
                        top: 8,
                        left: 10,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFF81D4FA),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 10,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFF81D4FA),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                      // Door
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 24,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00ACC1),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Happy kids row in front of the house
            Positioned(
              bottom: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _miniChild(Colors.orange, Colors.blue),
                  const SizedBox(width: 4),
                  _miniChild(Colors.pink, Colors.yellow),
                  const SizedBox(width: 4),
                  _miniChild(Colors.green, Colors.red),
                  const SizedBox(width: 4),
                  _miniChild(Colors.purple, Colors.cyan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniChild(Color hairColor, Color shirtColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCCBC),
            shape: BoxShape.circle,
            border: Border.all(color: hairColor, width: 2),
          ),
        ),
        Container(
          width: 18,
          height: 14,
          decoration: BoxDecoration(
            color: shirtColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _RoofPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Rainbow header icon widget matching dashboard greeting
class RainbowHeaderWidget extends StatelessWidget {
  const RainbowHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFB3E5FC), width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(48, 26),
            painter: _RainbowPainter(),
          ),
          Positioned(
            bottom: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _miniDot(Colors.pink),
                const SizedBox(width: 2),
                _miniDot(Colors.blue),
                const SizedBox(width: 2),
                _miniDot(Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _RainbowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.lightBlueAccent,
      Colors.purpleAccent,
    ];

    double radius = size.width / 2;
    final center = Offset(size.width / 2, size.height);

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (i * 2.2)),
        math.pi,
        math.pi,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Avatar for Children and Teachers
class CustomAvatarWidget extends StatelessWidget {
  final String? name;
  final String gender;
  final double size;
  final String? imageUrl;

  const CustomAvatarWidget({
    super.key,
    this.name,
    this.gender = 'ذكر',
    this.size = 56,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isFemale = gender.contains('انثى') || gender.contains('female') || (name != null && (name!.contains('سارة') || name!.contains('لينا') || name!.contains('فاطمة') || name!.contains('مريم') || name!.contains('نورة')));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFemale ? const Color(0xFFFFE0EB) : const Color(0xFFE0F2FE),
        border: Border.all(
          color: isFemale ? const Color(0xFFFF80AB) : const Color(0xFF81D4FA),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          isFemale ? Icons.face_3_rounded : Icons.face_rounded,
          size: size * 0.65,
          color: isFemale ? const Color(0xFFD81B60) : const Color(0xFF0288D1),
        ),
      ),
    );
  }
}

/// Classroom Icon Widget for Grid items
class ClassroomIconWidget extends StatelessWidget {
  final String iconType;
  final double size;

  const ClassroomIconWidget({
    super.key,
    required this.iconType,
    this.size = 55,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (iconType) {
      case 'butterfly':
        icon = Icons.flutter_dash;
        color = const Color(0xFFBA68C8);
        break;
      case 'star':
        icon = Icons.star_rounded;
        color = const Color(0xFFFFB300);
        break;
      case 'bear':
        icon = Icons.pets_rounded;
        color = const Color(0xFF29B6F6);
        break;
      case 'bee':
        icon = Icons.bug_report_rounded;
        color = const Color(0xFFFFA000);
        break;
      case 'heart':
        icon = Icons.favorite_rounded;
        color = const Color(0xFFE91E63);
        break;
      case 'flower':
      default:
        icon = Icons.local_florist_rounded;
        color = const Color(0xFFEC407A);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
      ),
      child: Icon(icon, size: size * 0.65, color: color),
    );
  }
}
