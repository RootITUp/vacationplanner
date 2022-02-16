import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vacation_planner/consts/leave_type.dart';
import 'package:vacation_planner/consts/states.dart';
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

  Future<List<Leave>> getLeaveDays() async {
    final SharedPreferences prefs = await _prefs;
    localLeaveList.clear();

    List<dynamic> userMap;
    if (prefs.containsKey("localLeaveList")) {
      userMap = await jsonDecode(prefs.getString('localLeaveList')!);
    } else {
      userMap = [];
    }

    for (var element in userMap) {
      localLeaveList.add(Leave.fromJson(element));
    }

    return localLeaveList;
  }

  Future<States> getSavedState() async {
    final SharedPreferences prefs = await _prefs;

    if (prefs.containsKey("selectedState")) {
      int stateIndex = prefs.getInt('selectedState')!;
      return States.values[stateIndex];
    } else {
      return States.NW;
    }
  }

  void addLeaveDay(DateTime day, LeaveType type) async {
    final SharedPreferences prefs = await _prefs;

    if (localLeaveList.contains(Leave(day, type))) {
    } else {
      localLeaveList.add(Leave(day, type));
    }

    prefs.remove("localLeaveList");
    prefs.setString("localLeaveList", jsonEncode(localLeaveList));
  }

  void removeLeaveDay(DateTime day, LeaveType type) async {
    final SharedPreferences prefs = await _prefs;
    localLeaveList.removeWhere((element) => element.date.isSameDate(day));

    prefs.setString("localLeaveList", jsonEncode(localLeaveList));
  }

  Future<void> saveLeaveDays(int days) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('paidLeaveDays', days);
  }

  Future<void> saveRestLeaveDays(int days) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('restPaidLeaveDays', days);
  }

  Future<void> saveSelectedState(States state) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('selectedState', state.index);
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
