import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/features/details/screens/timing_page.dart';
import 'package:alive_service_app/models/location.dart';
import 'package:alive_service_app/models/user_detail_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

final userDetailsRepositoryProvider = Provider((ref) => UserDetailsRepository(
    firebaseStorage: FirebaseStorage.instance,
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance));

class UserDetailsRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  UserDetailsRepository({
    required this.firebaseStorage,
    required this.firestore,
    required this.auth,
  });
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<List<Placemark>> getAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemark;
  }

  Future<List<Locations>> getlocation(String pincode) async {
    List<Locations> locations = [];
    JsonDecoder decoder = const JsonDecoder();
    await http
        .get(Uri.parse("http://www.postalpincode.in/api/pincode/$pincode"))
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      var json = decoder.convert(res);
      var tmp = json['PostOffice'] as List;
      locations =
          tmp.map<Locations>((json) => Locations.fromJson(json)).toList();
    });
    return locations;
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = File('$tempPath${rng.nextInt(100)}.png');
    // call http.get method and pass imageurl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
    // write bodybytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  void deleteUserData(String workType) async {
    final currUser = auth.currentUser!.uid;
    await firestore
        .collection('userDetails')
        .doc(workType)
        .collection('Users')
        .doc(currUser)
        .delete();
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('userDetails/$workType/$currUser/mainImage/main$currUser');
    await storageReference.delete();
    Reference folderReference = FirebaseStorage.instance
        .ref()
        .child('userDetails/$workType/$currUser/moreImage');
    ListResult result = await folderReference.listAll();
    for (Reference ref in result.items) {
      await ref.delete();
    }
  }

  void saveUserDetailData({
    required BuildContext context,
    required File mainImage,
    required List<XFile> moreImage,
    required String shopeName,
    required String workType,
    required List<Time> time,
    required Position position,
    required String discription,
  }) async {
    try {
      List<String> imageUrlList = [];
      String userId = auth.currentUser!.uid;
      var phoneNumber = auth.currentUser!.phoneNumber;
      UploadTask uploadTask = firebaseStorage
          .ref()
          .child('userDetails/$workType/$userId/mainImage/main$userId')
          .putFile(mainImage);
      TaskSnapshot snap = await uploadTask;
      String imageUrl = await snap.ref.getDownloadURL();
      int count = 1;
      for (XFile image in moreImage) {
        UploadTask uploadTask = firebaseStorage
            .ref()
            .child('userDetails/$workType/$userId/moreImage/more$userId$count')
            .putFile(File(image.path));
        TaskSnapshot snap = await uploadTask;
        String imagesUrl = await snap.ref.getDownloadURL();
        imageUrlList.add(imagesUrl);
        count++;
      }

      String timeIn =
          "${time[0].hour.toString().padLeft(2, '0')}:${time[0].minute.toString().padLeft(2, '0')} ${time[0].timeFormat}";
      String timeOut =
          "${time[1].hour.toString().padLeft(2, '0')}:${time[1].minute.toString().padLeft(2, '0')} ${time[1].timeFormat}";

      GeoFirePoint myLocation = GeoFlutterFire()
          .point(latitude: position.latitude, longitude: position.longitude);


      final userDetail = UserDetail(
          mainImage: imageUrl,
          moreImage: imageUrlList,
          shopeName: shopeName,
          workType: workType,
          timeIn: timeIn,
          timeOut: timeOut,
          latitude: position.latitude,
          logitude: position.longitude,
          discription: discription,
          phoneNumber: phoneNumber!);
      await firestore
          .collection('userDetails')
          .doc(workType)
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .set({
        ...userDetail.toMap(),
        'position': myLocation.data,
      });
      await firestore
          .collection('userDetails')
          .doc(workType)
          .set({'id': workType});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
