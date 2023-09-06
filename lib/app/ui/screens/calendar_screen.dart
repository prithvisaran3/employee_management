import 'package:employee_management/app/model/attendance_model.dart';
import 'package:employee_management/app/services/attendance_service.dart';
import 'package:employee_management/app/ui/themes/colors.dart';
import 'package:employee_management/app/ui/widgets/common/common_button.dart';
import 'package:employee_management/app/ui/widgets/common/common_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);

    return Scaffold(
        body: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20, top: 60, bottom: 10),
          child: const CommonText(
            text: "My Attendance",
            fontSize: 25,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CommonText(
              text: attendanceService.attendanceHistoryMonth,
              fontSize: 25,
            ),
            OutlinedButton(
              onPressed: () async {
                final selectedDate =
                    await SimpleMonthYearPicker.showMonthYearPickerDialog(
                  context: context,
                  disableFuture: true,
                );
                String pickedMonth =
                    DateFormat("MMMM yyyy").format(selectedDate);
                attendanceService.attendanceHistoryMonth = pickedMonth;
              },
              child: CommonText(
                text: "Pick a month",
                fontColor: AppColors.primary,
              ),
            ),
          ],
        ),
        Expanded(
            child: FutureBuilder(
          future: attendanceService.getAttendanceHistory(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    AttendanceModel attendanceData = snapshot.data![index];
                    return Container(
                      height: 120,
                      margin: const EdgeInsets.only(
                          top: 12, left: 15, right: 15, bottom: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              // margin: EdgeInsets.only(),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: CommonText(
                                  text: DateFormat("EE \n DD")
                                      .format(attendanceData.createdAt),
                                  fontSize: 18,
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CommonText(
                                  text: "Check in",
                                  fontSize: 20,
                                  fontColor: Colors.black54,
                                ),
                                const SizedBox(
                                  width: 80,
                                  child: Divider(),
                                ),
                                CommonText(
                                  text: attendanceData.check_in,
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
                                  text: attendanceData.check_out?.toString() ??
                                      "--/--",
                                  fontSize: 25,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CommonText(
                    text: "No data available",
                    fontSize: 25,
                  ),
                );
              }
            }
            return LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.grey,
            );
          },
        ))
      ],
    ));
  }
}
