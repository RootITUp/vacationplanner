import 'package:json_annotation/json_annotation.dart';
import 'package:vacation_planner/consts/leave_type.dart';

part 'leave.g.dart';

@JsonSerializable()
class Leave {
  final DateTime date;
  final LeaveType type;

  Leave(this.date, this.type);

  factory Leave.fromJson(Map<String, dynamic> json) => _$LeaveFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveToJson(this);

  @override
  String toString() {
    return 'Leave{date: $date, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Leave &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          type == other.type;

  @override
  int get hashCode => date.hashCode ^ type.hashCode;
}
