import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/consts/leave_type.dart';
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

    holidays = await _vacationRepository.getHolidays();
    schoolvacations = await _vacationRepository.getSchoolVacations();
    leaveList = _vacationRepository.getLeaveDays();

    emit(VacationLoadSuccess(
        holidayList: holidays,
        vacationList: schoolvacations,
        leaveList: leaveList));
  }

  void addLeave(DateTime day, LeaveType type) {
    var leaveDays = _vacationRepository.getLeaveDays();
    var currentLeaveDay =
        leaveDays.firstWhereOrNull((element) => element.date.isSameDate(day));

    if (currentLeaveDay == null) {
      _vacationRepository.getLeaveDays().add(Leave(day, type));
    } else {
      _vacationRepository.getLeaveDays().removeWhere(
          (element) => element.date.isSameDate(currentLeaveDay.date));
    }
  }
}
