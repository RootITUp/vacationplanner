import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/consts/leave_type.dart';
import 'package:vacation_planner/consts/states.dart';
import 'package:vacation_planner/extensions/datetime_extensions.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/leave.dart';
import 'package:vacation_planner/models/school_vacation.dart';

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
      onTapDown: (details) {
        setState(() {
          context
              .read<VacationCubit>()
              .switchLeave(widget.day, LeaveType.paidLeave);

          widget.updateHolidayDays;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: (widget.numberColumns == 1)
            ? (MediaQuery.of(context).size.height / 3 - 20) / 7
            : (MediaQuery.of(context).size.height / 5 - 20) / 6,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2),
            color: getColor(widget.day, widget.state.holidayList,
                widget.state.vacationList, widget.state.leaveList)),
        child: Center(
          child: Text(widget.day.day.toString()),
        ),
      ),
    );
  }

  Color? getColor(DateTime e, List<Holiday> holidayList,
      List<SchoolVacation> schoolvacations, List<Leave> leaveList) {
    if (e.isSameDate(leaveList
        .firstWhereOrNull(
          (element) => element.date.isSameDate(e),
        )
        ?.date)) {
      return Colors.cyanAccent;
    }

    if (widget.showHolidays) {
      if (e.isSameDate(holidayList
          .firstWhereOrNull((element) =>
              element.date.isSameDate(e) &&
              element.stateCode == widget.states.toShortString())
          ?.date)) {
        return Colors.red;
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
        return Colors.blue.withOpacity(0.6);
      }
    }

    if (e.weekday == 6) {
      return Colors.red.withOpacity(0.2);
    } else if (e.weekday == 7) {
      return Colors.red.withOpacity(0.3);
    } else {
      return null;
    }
  }
}
