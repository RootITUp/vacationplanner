class Holiday {
  final String name;
  final DateTime date;
  final String stateCode;

  Holiday(this.name, this.date, this.stateCode);

  Holiday.fromJson(Map<String, dynamic> json)
      : name =json['name']  as String,
        date = DateTime.parse(json['date']),
        stateCode = json['stateCode'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'stateCode': stateCode,
      };

  @override
  String toString() {
    return 'Holiday{name: $name, date: $date, stateCode: $stateCode}';
  }
}
