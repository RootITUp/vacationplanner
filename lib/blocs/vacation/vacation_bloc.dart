import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/consts/leave_type.dart';
import 'package:vacation_planner/consts/states.dart';
import 'package:vacation_planner/extensions/datetime_extensions.dart';
import 'package:vacation_planner/models/holiday.dart';
import 'package:vacation_planner/models/leave.dart';
import 'package:vacation_planner/models/school_vacation.dart';
import 'package:vacation_planner/repositories/vacation_repository.dart';

class VacationCubit extends Cubit<VacationState> {
  final VacationRepository _vacationRepository;

  VacationCubit({required VacationRepository vacationRepository})
      : _vacationRepository = vacationRepository,
        super(VacationsInitial.empty());

  Future<void> loadVacations() async {
    late final List<Holiday> holidays;
    late final List<SchoolVacation> schoolvacations;
    late final List<Leave> leaveList;
    late int amountLeaveDays;
    late int amountRestLeaveDays;
    late States selectedState;

    holidays = await _vacationRepository.getHolidays();
    schoolvacations = await _vacationRepository.getSchoolVacations();
    leaveList = await _vacationRepository.getLeaveDays();
    amountLeaveDays = await _vacationRepository.getAmountLeaveDays();
    amountRestLeaveDays = await _vacationRepository.getAmountRestLeaveDays();
    selectedState = await _vacationRepository.getSavedState();

    emit(VacationLoadSuccess(
        holidayList: holidays,
        vacationList: schoolvacations,
        leaveList: leaveList,
        amountLeaveDays: amountLeaveDays,
        amountRestLeaveDays: amountRestLeaveDays,
        selectedState: selectedState));
  }

  void switchLeave(DateTime day, LeaveType type) async {
    var leaveDays = await _vacationRepository.getLeaveDays();
    var currentLeaveDay =
        leaveDays.firstWhereOrNull((element) => element.date.isSameDate(day));

    if (currentLeaveDay == null) {
      _vacationRepository.addLeaveDay(day, type);
    } else {
      _vacationRepository.removeLeaveDay(day, type);
    }
  }

  Future<void> updateAmounts() async {
    emit(VacationLoadInProgress(
        leaveList: state.leaveList,
        vacationList: state.vacationList,
        holidayList: state.holidayList,
        amountLeaveDays: state.amountLeaveDays,
        amountRestLeaveDays: state.amountRestLeaveDays,
        selectedState: state.selectedState));

    emit(VacationLoadSuccess(
        leaveList: state.leaveList,
        vacationList: state.vacationList,
        holidayList: state.holidayList,
        amountLeaveDays: await _vacationRepository.getAmountLeaveDays(),
        amountRestLeaveDays: await _vacationRepository.getAmountRestLeaveDays(),
        selectedState: await _vacationRepository.getSavedState()));
  }

  Future<void> saveHolidayDays(int days) async {
    _vacationRepository.saveLeaveDays(days);
  }

  Future<void> saveRest(int days) async {
    _vacationRepository.saveRestLeaveDays(days);
  }

  Future<void> saveState(States state) async {
    _vacationRepository.saveSelectedState(state);
  }
}
