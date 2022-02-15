class CalendarMonth {
  final DateTime selectedMonth;

  CalendarMonth(this.selectedMonth);

  int weeks = 6;
  int days = 7;
  int months = 12;

  List<List<DateTime?>> _createCalendarArray(int month) {
    var firstDayMonth = DateTime(selectedMonth.year, month, 1);
    int firstWeekdayInMonth = firstDayMonth.weekday;
    var lastDayInMonth =
        DateTime(firstDayMonth.year, firstDayMonth.month + 1, 0);

    int daysInMonth = lastDayInMonth.difference(firstDayMonth).inDays + 1;

    int currentCounter = 0;
    return List.generate(weeks, (weekIndex) {
      return List<DateTime?>.generate(days, (dayIndex) {
        currentCounter++;

        if (currentCounter >= firstWeekdayInMonth &&
            currentCounter < firstWeekdayInMonth + daysInMonth) {
          return DateTime(firstDayMonth.year, firstDayMonth.month,
              firstDayMonth.day + currentCounter - firstWeekdayInMonth);
        }
        return null;
      }, growable: false);
    }, growable: false);
  }

  List<List<List<DateTime?>>> createCalendarArrayForWholeYear() {
    List<List<List<DateTime?>>> arraysForWholeYear = [];
    for (int i = 1; i <= months; i++) {
      arraysForWholeYear.add(_createCalendarArray(i));
    }

    return arraysForWholeYear;
  }
}
