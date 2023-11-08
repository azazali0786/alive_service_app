class UserDetail {
  final String mainImage;
  final List<String> moreImage;
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
      required this.phoneNumber
      });

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
      phoneNumber: map['phoneNumber'] as String
    );
  }

  // String toJson() => json.encode(toMap());
  // factory UserDetailModel.fromJson(String source) => UserDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
