import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/main.dart';
import '../../themes/colors.dart';

class HomeMain extends StatelessWidget {
  HomeMain({Key? key}) : super(key: key);
  final List<Widget> pages = [
    const Center(child: Text("Profile")),
    const Center(child: Text("Home")),
    const Center(child: Text("History")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => CurvedNavigationBar(
            // key: _bottomNavigationKey,
            index: MainController.to.pageIndex,
            height: 55.0,
            items: [
              buildDecoratedIcon(
                  icon: Icons.person,
                  color: MainController.to.isSelectIcon == 0
                      ? AppColors.primary
                      : AppColors.grey),
              Obx(() => buildDecoratedIcon(
                  icon: Icons.home_filled,
                  color: MainController.to.pageIndex == 1
                      ? AppColors.white
                      : AppColors.grey)),
              buildDecoratedIcon(
                  icon: Icons.calendar_month,
                  color: MainController.to.isSelectIcon == 2
                      ? AppColors.primary
                      : AppColors.grey),
            ],
            color: AppColors.grey.withOpacity(.10),
            buttonBackgroundColor: MainController.to.pageIndex == 1
                ? AppColors.primary
                : AppColors.secondary.withOpacity(.3),
            backgroundColor: AppColors.black.withOpacity(0),
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index) {
              MainController.to.pageIndex = index;
              MainController.to.isSelectIcon = index;
            },
            letIndexChange: (index) => true,
          )),
      body: Obx(() => pages[MainController.to.pageIndex]),
    );
  }

  Icon buildDecoratedIcon(
      {double size = 30.0, required IconData icon, required Color color}) {
    return Icon(
      icon,
      color: color,
      size: size,
      // shadows: const [
      //   BoxShadow(
      //       blurRadius: 1.0, color: AppColors.gradient, spreadRadius: 2.0),
      // ],
    );
  }
}
