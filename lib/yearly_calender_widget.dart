import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/widgets/calendar_day_container.dart';

import 'calendar_month_creator.dart';
import 'consts/states.dart';

class YearlyCalendar extends StatelessWidget {
  YearlyCalendar(this.updateHolidayDays,
      {Key? key,
      required this.year,
      required this.states,
      required this.state,
      required this.showHolidays,
      required this.showVacations,
      required this.numberColumns})
      : super(key: key);
  List<List<List<DateTime?>>> calendarMonthArray = [];
  final int year;
  final bool showHolidays;
  final bool showVacations;
  final int numberColumns;
  final VacationState state;

  final Function updateHolidayDays;
  final States states;

  final List<String> weekdays = ["MO", "DI", "MI", "DO", "FR", "SA", "SO"];

  @override
  Widget build(BuildContext context) {
    calendarMonthArray =
        CalendarMonth(DateTime(year, 1, 1)).createCalendarArrayForWholeYear();

    return BlocBuilder<VacationCubit, VacationState>(builder: (context, state) {
      if (state is VacationLoadSuccess) {
        return Center(
          child: Wrap(
              children: calendarMonthArray
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedContainer(
                          width: (numberColumns == 1)
                              ? MediaQuery.of(context).size.width / 1 - 20
                              : MediaQuery.of(context).size.width / 2 - 20,
                          duration: const Duration(milliseconds: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  child: Center(
                                child: Text(
                                  DateFormat.MMMM('de')
                                      .format(DateTime(2022,
                                          calendarMonthArray.indexOf(e) + 1))
                                      .toUpperCase(),
                                  textScaleFactor:
                                      (numberColumns == 1) ? 1.6 : 1.3,
                                ),
                              )),
                              Flexible(
                                child: Table(children: [
                                  TableRow(
                                      children: weekdays
                                          .map((e) => Container(
                                                child: Center(
                                                    child: Text(e,
                                                        textScaleFactor:
                                                            (numberColumns == 1)
                                                                ? 1.0
                                                                : 0.8)),
                                              ))
                                          .toList()),
                                  ...e
                                      .map((e) => TableRow(
                                          children: e
                                              .map(
                                                (e) => (e != null)
                                                    ? Padding(
                                                        padding: (numberColumns ==
                                                                1)
                                                            ? const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4.0)
                                                            : const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 0.0),
                                                        child: CalendarDay(
                                                            updateHolidayDays,
                                                            state: state,
                                                            showHolidays:
                                                                showHolidays,
                                                            showVacations:
                                                                showVacations,
                                                            numberColumns:
                                                                numberColumns,
                                                            states: states,
                                                            day: e),
                                                      )
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
                  .toList()),
        );
      } else {
        return Container();
      }
    });
  }
}
