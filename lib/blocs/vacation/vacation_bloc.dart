import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/models/holiday.dart';
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

    holidays = await _vacationRepository.getHolidays();
    schoolvacations = await _vacationRepository.getSchoolVacations();

    emit(VacationLoadSuccess(
        holidayList: holidays, vacationList: schoolvacations));
  }
}
