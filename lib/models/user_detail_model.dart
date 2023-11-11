import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDetail {
  final String mainImage;
  final List moreImage;
  final String shopeName;
  final String workType;
  final String timeIn;
  final String timeOut;
  final double latitude;
  final double logitude;
  final String discription;
  final String phoneNumber;
  UserDetail(
      {required this.mainImage,
      required this.moreImage,
      required this.shopeName,
      required this.workType,
      required this.timeIn,
      required this.timeOut,
      required this.latitude,
      required this.logitude,
      required this.discription,
      required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mainImage': mainImage,
      'moreImage': moreImage,
      'shopeName': shopeName,
      'workType': workType,
      'timeIn': timeIn,
      'timeOut': timeOut,
      'latitude': latitude,
      'logitude': logitude,
      'discription': discription,
      'phoneNumber': phoneNumber
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
        mainImage: map['mainImage'] as String,
        moreImage: List<String>.from((map['moreImage'] as List<String>)),
        shopeName: map['shopeName'] as String,
        workType: map['workType'] as String,
        timeIn: map['timeIn'] as String,
        timeOut: map['timeOut'] as String,
        latitude: map['latitude'] as double,
        logitude: map['logitude'] as double,
        discription: map['discription'] as String,
        phoneNumber: map['phoneNumber'] as String);
  }

  static UserDetail fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data()! as Map<String, dynamic>;
    return UserDetail(
      mainImage: snapshot["mainImage"] ?? "",
      moreImage: snapshot["moreImage"] ?? [],
      shopeName: snapshot["shopeName"] ?? "",
      workType: snapshot["workType"] ?? "",
      timeIn: snapshot["timeIn"] ?? "",
      timeOut: snapshot["timeOut"] ?? "",
      latitude: snapshot["latitude"] ?? 0.0,
      logitude: snapshot["longitude"] ?? 0.0,
      discription: snapshot["discription"] ?? "",
      phoneNumber: snapshot["phoneNumber"] ?? "",
    );
  }

}
