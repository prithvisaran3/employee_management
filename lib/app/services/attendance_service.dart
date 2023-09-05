import 'package:employee_management/app/model/attendance_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/constants.dart';
import '../utils/utils.dart';

class AttendanceService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  AttendanceModel? attendanceModel;

  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getTodayAttendance() async {
    final List result = await _supabase
        .from(Constants.attendanceTable)
        .select()
        .eq("employee_id", _supabase.auth.currentUser!.id)
        .eq('date', todayDate);
    if (result.isNotEmpty) {
      attendanceModel = AttendanceModel.fromJson(result.first);
    }
    notifyListeners();
  }

  Future markAttendance(BuildContext context) async {
    if (attendanceModel?.check_in == null) {
      await _supabase.from(Constants.attendanceTable).insert({
        "employee_id": _supabase.auth.currentUser!.id,
        "date": todayDate,
        "check_in": DateFormat("HH:mm").format(DateTime.now()),
      });
    } else if (attendanceModel?.check_out == null) {
      await _supabase
          .from(Constants.attendanceTable)
          .update({
            'check_out': DateFormat("HH:mm").format(DateTime.now()),
          })
          .eq("employee_id", _supabase.auth.currentUser!.id)
          .eq("date", todayDate);
    } else {
      Utils.showSnackBar("You have already checked out today!", context,
          color: Colors.green);
    }
    getTodayAttendance();
  }
}
