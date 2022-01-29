import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/school_vacation.dart';

class VacationRepository {
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
}
