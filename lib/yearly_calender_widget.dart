import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/widgets/calendar_day_container.dart';

import 'calendar_month_creator.dart';
import 'libraries/states.dart';

class YearlyCalendar extends StatelessWidget {
  YearlyCalendar(
      {Key? key,
      required this.year,
      required this.states,
      required this.showHolidays,
      required this.showVacations,
      required this.numberColumns})
      : super(key: key);
  List<List<List<DateTime?>>> calendarMonthArray = [];
  final int year;
  final bool showHolidays;
  final bool showVacations;
  final int numberColumns;

  final States states;

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
                      child: AnimatedContainer(
                        width: (numberColumns == 1)
                            ? MediaQuery.of(context).size.width / 1 - 20
                            : MediaQuery.of(context).size.width / 2 - 20,
                        duration: Duration(milliseconds: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
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
                            Flexible(
                              child: Table(children: [
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
                                                  ? CalendarDay(
                                                      showHolidays:
                                                          showHolidays,
                                                      showVacations:
                                                          showVacations,
                                                      numberColumns:
                                                          numberColumns,
                                                      state: states,
                                                      day: e)
                                                  : Container(),
                                            )
                                            .toList()))
                                    .toList(),
                              ]),
                            ),
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
