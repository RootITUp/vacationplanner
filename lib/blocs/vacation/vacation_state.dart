import 'package:equatable/equatable.dart';
import 'package:vacation_planner/consts/states.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/leave.dart';
import 'package:vacation_planner/models/school_vacation.dart';

abstract class VacationState extends Equatable {
  final List<Holiday> holidayList;
  final List<SchoolVacation> vacationList;
  final List<Leave> leaveList;
  final int amountLeaveDays;
  final int amountRestLeaveDays;
  final States selectedState;

  const VacationState(
      {required this.holidayList,
      required this.vacationList,
      required this.leaveList,
      required this.amountLeaveDays,
      required this.amountRestLeaveDays,
      required this.selectedState});

  @override
  List<Object> get props => [holidayList, vacationList];
}

class VacationsInitial extends VacationState {
  VacationsInitial.empty()
      : super(
            holidayList: [],
            vacationList: [],
            leaveList: [],
            amountLeaveDays: 30,
            amountRestLeaveDays: 0,
            selectedState: States.NW);
}

abstract class VacationsLoadState extends VacationState {
  const VacationsLoadState({
    required List<Holiday> holidayList,
    required List<SchoolVacation> vacationList,
    required List<Leave> leaveList,
    required int amountLeaveDays,
    required int amountRestLeaveDays,
    required States selectedState,
  }) : super(
            holidayList: holidayList,
            vacationList: vacationList,
            leaveList: leaveList,
            amountLeaveDays: amountLeaveDays,
            amountRestLeaveDays: amountRestLeaveDays,
            selectedState: selectedState);
}

class VacationLoadInProgress extends VacationsLoadState {
  const VacationLoadInProgress({
    required List<Holiday> holidayList,
    required List<SchoolVacation> vacationList,
    required List<Leave> leaveList,
    required int amountLeaveDays,
    required int amountRestLeaveDays,
    required States selectedState,
  }) : super(
            holidayList: holidayList,
            vacationList: vacationList,
            leaveList: leaveList,
            amountLeaveDays: amountLeaveDays,
            amountRestLeaveDays: amountRestLeaveDays,
            selectedState: selectedState);
}

class VacationLoadSuccess extends VacationsLoadState {
  const VacationLoadSuccess({
    required List<Holiday> holidayList,
    required List<SchoolVacation> vacationList,
    required List<Leave> leaveList,
    required int amountLeaveDays,
    required int amountRestLeaveDays,
    required States selectedState,
  }) : super(
            holidayList: holidayList,
            vacationList: vacationList,
            leaveList: leaveList,
            amountLeaveDays: amountLeaveDays,
            amountRestLeaveDays: amountRestLeaveDays,
            selectedState: selectedState);
}
