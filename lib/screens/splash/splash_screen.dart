import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/custom_illustrations.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Top pink accent tab
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 8,
                width: 150,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
                ),
              ),
            ),

            // Scattered Golden Stars matching XD design
            Positioned(
              top: 40,
              right: 40,
              child: const StarWidget(size: 32),
            ),
            Positioned(
              top: 90,
              left: 36,
              child: const StarWidget(size: 42),
            ),
            Positioned(
              top: size.height * 0.45,
              right: 28,
              child: const StarWidget(size: 40),
            ),
            Positioned(
              top: size.height * 0.62,
              left: 48,
              child: const StarWidget(size: 24),
            ),

            // Main Splash Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Central School & Kids Illustration
                  const KindergartenIllustrationWidget(size: 230),
                  const SizedBox(height: 32),

                  // Brand App Name
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),

                  // App Subtitle
                  const Text(
                    AppStrings.appSubtitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE55894),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading text
                  const Text(
                    AppStrings.loadingText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Animated Pink Pill Progress Bar
                  Container(
                    width: 200,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBCD0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: _progressController.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
