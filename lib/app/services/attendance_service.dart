import 'package:employee_management/app/model/attendance_model.dart';
import 'package:employee_management/app/services/location_service.dart';

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

  String _attendanceHistoryMonth =
      DateFormat("MMMM yyyy").format(DateTime.now());

  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set attendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
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
    Map? getLocation = await LocationService().initializeAndGetLocaton(context);
    if (getLocation != null) {
      if (attendanceModel?.check_in == null) {
        await _supabase.from(Constants.attendanceTable).insert({
          "employee_id": _supabase.auth.currentUser!.id,
          "date": todayDate,
          "check_in": DateFormat("HH:mm").format(DateTime.now()),
          'check_in_location': getLocation,
        });
      } else if (attendanceModel?.check_out == null) {
        await _supabase
            .from(Constants.attendanceTable)
            .update({
              'check_out': DateFormat("HH:mm").format(DateTime.now()),
              'check_out_location': getLocation,
            })
            .eq("employee_id", _supabase.auth.currentUser!.id)
            .eq("date", todayDate);
      } else {
        Utils.showSnackBar("You have already checked out today!", context,
            color: Colors.green);
      }
      getTodayAttendance();
    } else {
      Utils.showSnackBar("Not able to get your location", context,
          color: Colors.red);
    }
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    // print("DATE: ${attendanceHistoryMonth}");
    final List data = await _supabase
        .from(Constants.attendanceTable)
        .select()
        .eq("employee_id", _supabase.auth.currentUser!.id)
        .textSearch('date', "'$attendanceHistoryMonth'", config: 'english')
        .order('created_at', ascending: false);
    print("DATA: ${data}");
    return data
        .map((attendance) => AttendanceModel.fromJson(attendance))
        .toList();
  }
}
