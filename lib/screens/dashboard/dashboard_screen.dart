import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/custom_illustrations.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).fetchSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final summary = dashboardProvider.summary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => dashboardProvider.fetchSummary(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top pink notch tab
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 8,
                    width: 140,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Arrow
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    // Greeting
                    const Text(
                      AppStrings.welcome,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    // Rainbow Banner Graphic
                    const RainbowHeaderWidget(),
                  ],
                ),
                const SizedBox(height: 16),

                // Blue Welcome Banner Card
                Container(
                  height: 145,
                  decoration: BoxDecoration(
                    color: AppColors.bannerBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A0288D1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Text Description
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20, left: 10),
                          child: Text(
                            AppStrings.schoolBannerText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      // School Kids Graphic
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildStudentFigure(Colors.pink, isGirl: true),
                            const SizedBox(width: 6),
                            _buildStudentFigure(Colors.blue, isGirl: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Summary Title in Pink
                const Text(
                  AppStrings.quickSummary,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 18),

                // 4 Statistic Summary Cards Grid
                Row(
                  children: [
                    // Children Stat Card
                    Expanded(
                      child: StatCard(
                        title: AppStrings.childrenCount,
                        value: '${summary.childrenCount}',
                        unit: AppStrings.childUnit,
                        backgroundColor: AppColors.statChildrenBg,
                        iconWidget: const CustomAvatarWidget(
                          gender: 'ذكر',
                          size: 46,
                        ),
                        onTap: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(1); // Switch to Children Tab
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Teachers Stat Card
                    Expanded(
                      child: StatCard(
                        title: AppStrings.teachersCount,
                        value: '${summary.teachersCount}',
                        unit: AppStrings.teacherUnit,
                        backgroundColor: AppColors.statTeachersBg,
                        iconWidget: const CustomAvatarWidget(
                          gender: 'معلم',
                          size: 46,
                        ),
                        onTap: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(2); // Switch to Teachers Tab
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // Today Attendance Stat Card
                    Expanded(
                      child: StatCard(
                        title: AppStrings.todayAttendance,
                        value: '${summary.todayAttendance}',
                        unit: AppStrings.attendanceUnit,
                        backgroundColor: AppColors.statAttendanceBg,
                        iconWidget: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8E6C9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.event_available_rounded,
                            color: Color(0xFF2E7D32),
                            size: 30,
                          ),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('سجل حضور اليوم: 26 طفل حاضر')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Parents Stat Card
                    Expanded(
                      child: StatCard(
                        title: AppStrings.parentsCount,
                        value: '${summary.parentsCount}',
                        unit: AppStrings.parentUnit,
                        backgroundColor: AppColors.statParentsBg,
                        iconWidget: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECB3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.family_restroom_rounded,
                            color: Color(0xFFF57F17),
                            size: 30,
                          ),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('عدد أولياء الأمور المسجلين: 28')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentFigure(Color color, {required bool isGirl}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFD1DF),
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            isGirl ? Icons.face_3_rounded : Icons.face_rounded,
            color: color,
            size: 26,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.school_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
