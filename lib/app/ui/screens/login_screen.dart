import 'package:employee_management/app/services/auth_service.dart';
import 'package:employee_management/app/ui/screens/register_screen.dart';
import 'package:employee_management/app/ui/themes/colors.dart';
import 'package:employee_management/app/ui/widgets/common/common_button.dart';
import 'package:employee_management/app/ui/widgets/common/common_text.dart';
import 'package:employee_management/app/ui/widgets/common/common_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              height: screenHeight / 3,
              width: screenWidth,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 80,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CommonText(
                    text: "Employee",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CommonTextFormField(
                    prefixIcon: Icons.person,
                    hintText: "Employee Email ID",
                    controller: _emailController,
                  ),
                  // const SizedBox(height: 20),
                  CommonTextFormField(
                    obscureText: true,
                    prefixIcon: Icons.lock,
                    hintText: "Employee Password",
                    controller: _passwordController,
                  ),
                  SizedBox(height: 30),
                  Consumer<AuthService>(
                    builder: (context, authServiceProvider, child) {
                      return authServiceProvider.isLoading == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : CommonButton(
                              text: "Login",
                              onPressed: () {
                                authServiceProvider.loginEmployee(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    context);
                              },
                            );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: CommonText(
                      text: 'Are you a new Employee? Register Here',
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
