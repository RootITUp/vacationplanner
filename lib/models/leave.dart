
import 'package:vacation_planner/consts/leave_type.dart';

class Leave {
  final DateTime date;
  final LeaveType type;

  Leave(this.date, this.type);

  Leave.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        type = LeaveType.values[json['type']];

  Map<String, Object> toJson() => {'date': date, 'type': type.index};
}
