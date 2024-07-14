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
  final double overallRating;
  final int ratingCount;
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
      required this.phoneNumber,
      required this.overallRating,
      required this.ratingCount});

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
      'phoneNumber': phoneNumber,
      'overallRating': overallRating,
      'ratingCount': ratingCount
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
        mainImage: map['mainImage'] as String,
        moreImage: map['moreImage'] as List<dynamic>,
        shopeName: map['shopeName'] as String,
        workType: map['workType'] as String,
        timeIn: map['timeIn'] as String,
        timeOut: map['timeOut'] as String,
        latitude: map['latitude'] as double,
        logitude: map['logitude'] as double,
        discription: map['discription'] as String,
        phoneNumber: map['phoneNumber'] as String,
        overallRating: map['overallRating'] as double,
        ratingCount: map['ratingCount'] as int);
  }
}
