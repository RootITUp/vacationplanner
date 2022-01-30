extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime? other) {
    if (other == null) {
      return false;
    }
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DateBetween on DateTime {
  bool isDateBetween(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return false;
    }

    if ((isSameDate(start) || isAfter(start)) &&
        (isSameDate(end) || isBefore(end))) {
      return true;
    }

    return false;
  }
}
