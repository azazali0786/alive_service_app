import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CallDetail {
  final String mainImage;
  final String shopName;
  final String workerId;
  final String workType;
  final Timestamp timestamp;
  CallDetail({
    required this.mainImage,
    required this.shopName,
    required this.workerId,
    required this.workType,
    required this.timestamp
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainImage': mainImage,
      'shopName': shopName,
      'workerId': workerId,
      'workType': workType,
      'timestamp': timestamp
    };
  }

  factory CallDetail.fromMap(Map<String, dynamic> map) {
    return CallDetail(
      mainImage: map['mainImage'] as String,
      shopName: map['shopName'] as String,
      workerId: map['workerId'] as String,
      workType: map['workType'] as String,
      timestamp: map['timestamp'] as Timestamp
    );
  }

  String toJson() => json.encode(toMap());

  factory CallDetail.fromJson(String source) =>
      CallDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
