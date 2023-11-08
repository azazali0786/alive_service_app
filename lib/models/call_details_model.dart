class CallDetail {
  final String workerId;
  final String workType;
  final String timeIn;
  final String date;
  CallDetail({
    required this.workerId,
    required this.workType,
    required this.timeIn,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workerId': workerId,
      'workType': workType,
      'timeIn': timeIn,
      'date': date,
    };
  }

  factory CallDetail.fromMap(Map<String, dynamic> map) {
    return CallDetail(
      workerId: map['workerId'] as String,
      workType: map['workType'] as String,
      timeIn: map['timeIn'] as String,
      date: map['date'] as String,
    );
  }

  // String toJson() => json.encode(toMap());
  // factory CallDetail.fromJson(String source) => CallDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
