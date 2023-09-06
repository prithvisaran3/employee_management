import 'package:employee_management/app/services/db_service.dart';
import 'package:employee_management/app/ui/themes/colors.dart';
import 'package:employee_management/app/ui/widgets/common/common_button.dart';
import 'package:employee_management/app/ui/widgets/common/common_text.dart';
import 'package:employee_management/app/ui/widgets/common/common_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/department_model.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    final authService = Provider.of<AuthService>(context);

    //using below conditions because build can be called multiply times while using notify listeners
    dbService.allDepartments.isEmpty ? dbService.getAllDepartments() : null;
    nameController.text.isEmpty
        ? nameController.text = dbService.userModel?.name ?? 'Enter your name'
        : null;
    return SafeArea(
      child: Scaffold(
        body: dbService.userModel == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          authService.signOut();
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.only(right: 20, top: 20),
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                )
                              ],
                              borderRadius: BorderRadius.circular(8)),
                          child: const CommonText(
                            text: "Logout",
                            fontColor: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(top: 80),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.primary,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          CommonText(
                              text:
                                  "Employee ID: ${dbService.userModel?.employeeId}"),
                          const SizedBox(height: 15),
                          CommonTextFormField(
                              hintText: "Full Name",
                              controller: nameController),
                          const SizedBox(height: 15),
                          dbService.allDepartments.isEmpty
                              ? const LinearProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: DropdownButtonFormField(
                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                    focusColor: AppColors.primary,
                                    decoration: const InputDecoration(
                                      focusColor: AppColors.primary,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    value: dbService.employeeDepartment ??
                                        dbService.allDepartments.first.id,
                                    items: dbService.allDepartments
                                        .map((DepartmentModel item) {
                                      return DropdownMenuItem(
                                        value: item.id,
                                        child: CommonText(
                                          text: item.title,
                                          fontSize: 20,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      dbService.employeeDepartment =
                                          selectedValue;
                                    },
                                  ),
                                ),
                          const SizedBox(height: 40),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: CommonButton(
                              text: "Update Profile",
                              onPressed: () {
                                dbService.updateProfile(
                                    nameController.text.trim(), context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
