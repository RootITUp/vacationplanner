import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vacation_planner/consts/leave_type.dart';
import 'package:vacation_planner/extensions/datetime_extensions.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/leave.dart';
import 'package:vacation_planner/models/school_vacation.dart';

class VacationRepository {
  List<Leave> localLeaveList = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Holiday>> getHolidays() async {
    List<dynamic> userMap =
        await rootBundle.loadString("assets/holidays.json").then((jsonStr) {
      return json.decode(jsonStr)['holidays'];
    });

    List<Holiday> localList = [];

    for (var element in userMap) {
      localList.add(Holiday.fromJson(element));
    }

    return localList;
  }

  Future<List<SchoolVacation>> getSchoolVacations() async {
    List<dynamic> userMap = await rootBundle
        .loadString("assets/school_vacations.json")
        .then((jsonStr) {
      return json.decode(jsonStr)['schoolvacations'];
    });

    List<SchoolVacation> localList = [];

    for (var element in userMap) {
      localList.add(SchoolVacation.fromJson(element));
    }

    return localList;
  }

  List<Leave> getLeaveDays() {
    return localLeaveList;
  }

  void addLeaveDay(DateTime day, LeaveType type) async {
    final SharedPreferences prefs = await _prefs;

    localLeaveList.add(Leave(day, type));

    prefs.setString("localList", jsonEncode(localLeaveList));
  }

  void removeLeaveDay(DateTime day, LeaveType type) {
    localLeaveList.removeWhere((element) => element.date.isSameDate(day));
  }

  Future<void> saveLeaveDays(int days) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('paidLeaveDays', days);
  }

  Future<void> saveRestLeaveDays(int days) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('restPaidLeaveDays', days);
  }

  Future<int> getAmountLeaveDays() async {
    var amountLeaveDays = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('paidLeaveDays') ?? 30;
    });

    return amountLeaveDays;
  }

  Future<int> getAmountRestLeaveDays() async {
    var amountLeaveDays = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('restPaidLeaveDays') ?? 0;
    });

    return amountLeaveDays;
  }
}
