import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_theme.dart';
import 'core/storage/hive_storage.dart';
import 'providers/auth_provider.dart';
import 'providers/children_provider.dart';
import 'providers/classrooms_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/teachers_provider.dart';
import 'screens/main_navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة وتفعيل التخزين المحلي Hive للعمل بنمط Offline-First Caching
  await Hive.initFlutter();
  await Hive.openBox(HiveBoxes.childrenBox);
  await Hive.openBox(HiveBoxes.teachersBox);
  await Hive.openBox(HiveBoxes.classroomsBox);

  runApp(const KindergartenApp());
}

class KindergartenApp extends StatelessWidget {
  const KindergartenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ChildrenProvider()),
        ChangeNotifierProvider(create: (_) => TeachersProvider()),
        ChangeNotifierProvider(create: (_) => ClassroomsProvider()),
      ],
      child: MaterialApp(
        title: 'حضانتي - نظام إدارة حضانة أطفال',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
   home: const MainNavigationWrapper(),
      ),
    );
  }
}
