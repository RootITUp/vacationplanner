import 'package:equatable/equatable.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/leave.dart';
import 'package:vacation_planner/models/school_vacation.dart';

abstract class VacationState extends Equatable {
  final List<Holiday> holidayList;
  final List<SchoolVacation> vacationList;
  final List<Leave> leaveList;

  const VacationState(
      {required this.holidayList,
      required this.vacationList,
      required this.leaveList});

  @override
  List<Object> get props => [holidayList, vacationList];
}

class VacationsInitial extends VacationState {
  VacationsInitial.empty()
      : super(
          holidayList: [],
          vacationList: [],
          leaveList: [],
        );
}

abstract class VacationsLoadState extends VacationState {
  const VacationsLoadState({
    required List<Holiday> holidayList,
    required List<SchoolVacation> vacationList,
    required List<Leave> leaveList,
  }) : super(
            holidayList: holidayList,
            vacationList: vacationList,
            leaveList: leaveList);
}

class VacationLoadSuccess extends VacationsLoadState {
  const VacationLoadSuccess({
    required List<Holiday> holidayList,
    required List<SchoolVacation> vacationList,
    required List<Leave> leaveList,
  }) : super(
            holidayList: holidayList,
            vacationList: vacationList,
            leaveList: leaveList);
}
