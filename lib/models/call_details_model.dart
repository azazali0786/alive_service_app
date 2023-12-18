import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CallDetail {
  final String mainImage;
  final String shopName;
  final String workerId;
  final String workType;
  final String timeIn;
  final String date;
  CallDetail({
    required this.mainImage,
    required this.shopName,
    required this.workerId,
    required this.workType,
    required this.timeIn,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainImage': mainImage,
      'shopName': shopName,
      'workerId': workerId,
      'workType': workType,
      'timeIn': timeIn,
      'date': date,
    };
  }

  factory CallDetail.fromMap(Map<String, dynamic> map) {
    return CallDetail(
      mainImage: map['mainImage'] as String,
      shopName: map['shopName'] as String,
      workerId: map['workerId'] as String,
      workType: map['workType'] as String,
      timeIn: map['timeIn'] as String,
      date: map['date'] as String,
    );
  }

  // String toJson() => json.encode(toMap());
  // factory CallDetail.fromJson(String source) => CallDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  factory CallDetail.fromJson(String source) => CallDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
