import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/consts/leave_type.dart';
import 'package:vacation_planner/consts/states.dart';
import 'package:vacation_planner/extensions/datetime_extensions.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/leave.dart';
import 'package:vacation_planner/models/school_vacation.dart';
import 'package:vacation_planner/theme_provider.dart';

class CalendarDay extends StatefulWidget {
  const CalendarDay(this.updateHolidayDays,
      {Key? key,
      required this.showHolidays,
      required this.showVacations,
      required this.numberColumns,
      required this.state,
      required this.states,
      required this.day})
      : super(key: key);

  final VacationState state;
  final bool showHolidays;
  final bool showVacations;
  final int numberColumns;
  final States states;
  final Function updateHolidayDays;
  final DateTime day;

  @override
  _CalendarDayState createState() => _CalendarDayState();
}

class _CalendarDayState extends State<CalendarDay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          context
              .read<VacationCubit>()
              .switchLeave(widget.day, LeaveType.paidLeave);

          context.read<VacationCubit>().updateAmounts();

          widget.updateHolidayDays();
        });
      },
      onLongPress: () {
        setState(() {
          context
              .read<VacationCubit>()
              .switchLeave(widget.day, LeaveType.flexible);

          context.read<VacationCubit>().updateAmounts();

          widget.updateHolidayDays();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: (widget.numberColumns == 1)
                  ? (MediaQuery.of(context).size.height / 3 - 20) / 7
                  : (MediaQuery.of(context).size.height / 5 - 20) / 6,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getColor(widget.day, widget.state.holidayList,
                      widget.state.vacationList, widget.state.leaveList)),
              child: Center(
                child: Text(
                  widget.day.day.toString(),
                  textScaleFactor: (widget.numberColumns == 1) ? 1.0 : 0.8,
                  textAlign: TextAlign.center,
                  textHeightBehavior:
                      const TextHeightBehavior(applyHeightToLastDescent: true),
                  style: TextStyle(
                    color: (Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            if (widget.day.weekday == 1)
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  weekNumber(widget.day).toString(),
                  textScaleFactor: (widget.numberColumns == 1) ? 0.6 : 0.5,
                  style: TextStyle(
                    color: (Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark)
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Color? getColor(DateTime e, List<Holiday> holidayList,
      List<SchoolVacation> schoolvacations, List<Leave> leaveList) {
    if (e.isSameDate(leaveList
        .firstWhereOrNull(
          (element) =>
              element.date.isSameDate(e) && element.type == LeaveType.paidLeave,
        )
        ?.date)) {
      return const Color(0xffeaac8b);
    } else if (e.isSameDate(leaveList
        .firstWhereOrNull(
          (element) =>
              element.date.isSameDate(e) && element.type == LeaveType.flexible,
        )
        ?.date)) {
      return const Color(0xffeaac8b).withRed(0);
    }

    if (widget.showHolidays) {
      if (e.isSameDate(holidayList
          .firstWhereOrNull((element) =>
              element.date.isSameDate(e) &&
              element.stateCode == widget.states.toShortString())
          ?.date)) {
        return const Color(0xffe56b6f);
      }
    }

    if (widget.showVacations) {
      var firstWhereSchoolvacations = schoolvacations.firstWhereOrNull(
        (element) =>
            e.isDateBetween(element.startDate, element.endDate) &&
            element.stateCode == widget.states.toShortString(),
      );

      if (e.isDateBetween(firstWhereSchoolvacations?.startDate,
          firstWhereSchoolvacations?.endDate)) {
        return const Color(0xffb56576).withOpacity(0.6);
      }
    }

    if (e.weekday == 6) {
      return const Color(0xffe56b6f).withOpacity(0.1);
    } else if (e.weekday == 7) {
      return const Color(0xffe56b6f).withOpacity(0.15);
    } else {
      return (Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark)
          ? Colors.white.withOpacity(0.1)
          : const Color(0xFF355070).withOpacity(0.1);
    }
  }

  int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }
}
