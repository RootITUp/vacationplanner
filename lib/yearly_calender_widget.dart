import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/school_vacation.dart';

import 'calendar_month_creator.dart';
import 'libraries/states.dart';

class YearlyCalendar extends StatelessWidget {
  YearlyCalendar({Key? key, required this.year, required this.state})
      : super(key: key);
  List<List<List<DateTime?>>> calendarMonthArray = [];
  final int year;

  final States state;

  final List<String> weekdays = ["MO", "DI", "MI", "DO", "FR", "SA", "SO"];

  @override
  Widget build(BuildContext context) {
    calendarMonthArray =
        CalendarMonth(DateTime(year, 1, 1)).createCalendarArrayForWholeYear();

    return BlocBuilder<VacationCubit, VacationState>(builder: (context, state) {
      if (state is VacationLoadSuccess) {
        return Wrap(
            children: calendarMonthArray
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 0.2),
                                    color: Colors.greenAccent.withOpacity(0.5)),
                                child: Center(
                                  child: Text(DateFormat.MMMM('de').format(
                                      DateTime(2022,
                                          calendarMonthArray.indexOf(e) + 1))),
                                )),
                            Table(children: [
                              TableRow(
                                  children: weekdays
                                      .map((e) => Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.5),
                                                color: Colors.greenAccent
                                                    .withOpacity(0.2)),
                                            child: Center(child: Text(e)),
                                          ))
                                      .toList()),
                              ...e
                                  .map((e) => TableRow(
                                      children: e
                                          .map(
                                            (e) => (e != null)
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 0.2),
                                                        color: getColor(
                                                            e,
                                                            state.holidayList,
                                                            state
                                                                .vacationList)),
                                                    child: Center(
                                                      child: Text(
                                                          e.day.toString()),
                                                    ),
                                                  )
                                                : Container(),
                                          )
                                          .toList()))
                                  .toList(),
                            ]),
                          ],
                        ),
                      ),
                    ))
                .toList());
      } else {
        return Container();
      }
    });
  }

  Color? getColor(DateTime e, List<Holiday> holidayList,
      List<SchoolVacation> schoolvacations) {
    var firstWhereHoliday = holidayList.firstWhere(
        (element) =>
            element.date.isSameDate(e) &&
            element.stateCode == state.toShortString(),
        orElse: () => Holiday("test", DateTime(2022, 1, 1), "BE"));
    var firstWhereSchoolvacations = schoolvacations.firstWhere(
        (element) =>
            e.isDateBetween(element.startDate, element.endDate) &&
            element.stateCode == state.toShortString(),
        orElse: () => SchoolVacation("test", DateTime(2022, 1, 1),
            DateTime(2022, 1, 1), state.toShortString()));

    print(firstWhereSchoolvacations.startDate);

    if (e.isSameDate(firstWhereHoliday.date)) {
      return Colors.red;
    } else if (e.isDateBetween(firstWhereSchoolvacations.startDate,
        firstWhereSchoolvacations.endDate)) {
      return Colors.blue.withOpacity(0.5);
    } else if (e.weekday == 6) {
      return Colors.red.withOpacity(0.1);
    } else if (e.weekday == 7) {
      return Colors.red.withOpacity(0.2);
    } else {
      return null;
    }
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DateBetween on DateTime {
  bool isDateBetween(DateTime start, DateTime end) {
    if ((isSameDate(start) || isAfter(start)) &&
        (isSameDate(end) || isBefore(end))) {
      return true;
    }

    return false;
  }
}
