import 'package:employee_management/app/services/auth_service.dart';
import 'package:employee_management/app/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // authService.signOut();

    return authService.currentUser == null ? LoginScreen() : HomeScreen();
  }
}
