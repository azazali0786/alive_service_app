import 'dart:io';
import 'package:alive_service_app/features/details/repository/user_details_repository.dart';
import 'package:alive_service_app/features/details/screens/timing_page.dart';
import 'package:alive_service_app/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

final userDetailsControllerProvider = Provider((ref) {
  final userDetailsRepository = ref.watch(userDetailsRepositoryProvider);
  return UserDetailsController(userDetailsRepository: userDetailsRepository);
});

class UserDetailsController {
  final UserDetailsRepository userDetailsRepository;

  UserDetailsController({required this.userDetailsRepository});

  Future<Position> getCurrentLocation() {
    return userDetailsRepository.getCurrentLocation();
  }

  Future<List<Placemark>> getAddressFromLatLong(String lati,String logi) {
    return userDetailsRepository.getAddressFromLatLong(lati,logi);
  }

  Future<List<Locations>> getlocation(String pincode) async {
    return await userDetailsRepository.getlocation(pincode);
  }

  Future<File> urlToFile(String imageUrl) async {
    return userDetailsRepository.urlToFile(imageUrl);
  }

  void deleteUserData(String workType) {
    return userDetailsRepository.deleteUserData(workType);
  }

  void saveUserDetailData(
    BuildContext context,
    File mainImage,
    List<XFile> moreImage,
    String shopeName,
    String workType,
    List<Time> time,
    Position position,
    String discription,
  ) {
    return userDetailsRepository.saveUserDetailData(
        context: context,
        mainImage: mainImage,
        moreImage: moreImage,
        shopeName: shopeName,
        workType: workType,
        time: time,
        position: position,
        discription: discription);
  }
}
