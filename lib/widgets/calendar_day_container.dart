import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/libraries/states.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/school_vacation.dart';
import 'package:vacation_planner/yearly_calender_widget.dart';

class CalendarDay extends StatefulWidget {
  CalendarDay(
      {Key? key,
      required this.showHolidays,
      required this.showVacations,
      required this.numberColumns,
      required this.state,
      required this.day})
      : super(key: key);

  final bool showHolidays;
  final bool showVacations;
  final int numberColumns;
  final States state;
  var day;

  @override
  _CalendarDayState createState() => _CalendarDayState();
}

class _CalendarDayState extends State<CalendarDay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VacationCubit, VacationState>(builder: (context, state) {
      if (state is VacationLoadSuccess) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: (widget.numberColumns == 1)
              ? (MediaQuery.of(context).size.height / 3 - 20) / 7
              : (MediaQuery.of(context).size.height / 5 - 20) / 6,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.2),
              color:
                  getColor(widget.day, state.holidayList, state.vacationList)),
          child: Center(
            child: Text(widget.day.day.toString()),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Color? getColor(DateTime e, List<Holiday> holidayList,
      List<SchoolVacation> schoolvacations) {
    if (widget.showHolidays) {
      var firstWhereHoliday = holidayList.firstWhere(
          (element) =>
              element.date.isSameDate(e) &&
              element.stateCode == widget.state.toShortString(),
          orElse: () => Holiday("test", DateTime(2022, 1, 1), "BE"));

      if (e.isSameDate(firstWhereHoliday.date)) {
        return Colors.red;
      }
    }

    if (widget.showVacations) {
      var firstWhereSchoolvacations = schoolvacations.firstWhere(
          (element) =>
              e.isDateBetween(element.startDate, element.endDate) &&
              element.stateCode == widget.state.toShortString(),
          orElse: () => SchoolVacation("test", DateTime(2022, 1, 1),
              DateTime(2022, 1, 1), widget.state.toShortString()));

      if (e.isDateBetween(firstWhereSchoolvacations.startDate,
          firstWhereSchoolvacations.endDate)) {
        return Colors.blue.withOpacity(0.5);
      }
    }

    if (e.weekday == 6) {
      return Colors.red.withOpacity(0.1);
    } else if (e.weekday == 7) {
      return Colors.red.withOpacity(0.2);
    } else {
      return null;
    }
  }
}
