import 'package:equatable/equatable.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/school_vacation.dart';

abstract class VacationState extends Equatable {
  final List<Holiday> holidayList;
  final List<SchoolVacation> vacationList;

  const VacationState({required this.holidayList, required this.vacationList});

  @override
  List<Object> get props => [holidayList, vacationList];
}

class VacationsInitial extends VacationState {
  VacationsInitial.empty()
      : super(
          holidayList: [],
          vacationList: [],
        );
}

abstract class VacationsLoadState extends VacationState {
  const VacationsLoadState({
    required List<Holiday> holidayList,
    required List<SchoolVacation> vacationList,
  }) : super(holidayList: holidayList, vacationList: vacationList);
}

class VacationLoadSuccess extends VacationsLoadState {
  const VacationLoadSuccess({
    required List<Holiday> holidayList,
    required List<SchoolVacation> vacationList,
  }) : super(
          holidayList: holidayList,
          vacationList: vacationList,
        );
}
