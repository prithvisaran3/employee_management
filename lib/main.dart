import 'package:employee_management/app/config/config.dart';
import 'package:employee_management/app/services/attendance_service.dart';
import 'package:employee_management/app/services/auth_service.dart';
import 'package:employee_management/app/services/db_service.dart';
import 'package:employee_management/app/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/ui/themes/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: AppConfig.SupaBase_URL, anonKey: AppConfig.SupaBase_KEY);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: AppColors.primary, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => DbService()),
        ChangeNotifierProvider(create: (context) => AttendanceService()),
      ],
      child: const MaterialApp(
        title: 'Employee Attendance',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
