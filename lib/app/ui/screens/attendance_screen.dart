import 'package:employee_management/app/services/attendance_service.dart';
import 'package:employee_management/app/services/db_service.dart';
import 'package:employee_management/app/ui/themes/colors.dart';
import 'package:employee_management/app/ui/widgets/common/common_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../model/user_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();

  @override
  void initState() {
    Provider.of<AttendanceService>(context, listen: false).getTodayAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            welcomeSection(),
            todaystatusSection(attendanceService),
            currentDateTimeSection(),
            slideButton(attendanceService)
          ],
        ),
      ),
    );
  }

  Widget slideButton(AttendanceService attendanceService) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Builder(
        builder: (context) {
          return SlideAction(
            text: attendanceService.attendanceModel?.check_in == null
                ? "Slide to Check In"
                : "Slide to Check Out",
            textStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 18,
            ),
            outerColor: Colors.white,
            innerColor: AppColors.primary,
            key: key,
            onSubmit: () async {
              attendanceService.markAttendance(context);
              key.currentState!.reset();
            },
          );
        },
      ),
    );
  }

  Column currentDateTimeSection() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: CommonText(
            text: DateFormat("dd MMMM yyyy").format(DateTime.now()),
            fontSize: 20,
          ),
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Container(
                alignment: Alignment.centerLeft,
                child: CommonText(
                  text: DateFormat("hh:mm:ss a").format(DateTime.now()),
                  fontSize: 15,
                  fontColor: Colors.black54,
                ),
              );
            }),
      ],
    );
  }

  Column todaystatusSection(AttendanceService attendanceService) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 32),
          child: const CommonText(
            text: "Today's Status",
            fontSize: 20,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 32),
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2),
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CommonText(
                      text: "Check In",
                      fontSize: 20,
                      fontColor: Colors.black54,
                    ),
                    const SizedBox(
                      width: 80,
                      child: Divider(),
                    ),
                    CommonText(
                      text: attendanceService.attendanceModel?.check_in ??
                          '--/--',
                      fontSize: 25,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CommonText(
                      text: "Check Out",
                      fontSize: 20,
                      fontColor: Colors.black54,
                    ),
                    const SizedBox(
                      width: 80,
                      child: Divider(),
                    ),
                    CommonText(
                      text: attendanceService.attendanceModel?.check_out ??
                          '--/--',
                      fontSize: 25,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Column welcomeSection() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 32),
          child: CommonText(
            text: 'Welcome',
            fontColor: Colors.black54,
            fontSize: 30,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Consumer<DbService>(
          builder: (context, dbService, child) {
            return FutureBuilder(
              future: dbService.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data!;
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: CommonText(
                      text: user.name != ''
                          ? '${user.name}'
                          : "#${user.employeeId}",
                      fontSize: 25,
                    ),
                  );
                }
                return SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
