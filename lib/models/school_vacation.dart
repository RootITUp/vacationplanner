class SchoolVacation {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String stateCode;

  SchoolVacation(this.name, this.startDate, this.endDate, this.stateCode);

  SchoolVacation.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        startDate = DateTime.parse(json['start']),
        endDate = DateTime.parse(json['end']),
        stateCode = json['stateCode'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'start': startDate,
        'end': endDate,
        'stateCode': stateCode,
      };
}
