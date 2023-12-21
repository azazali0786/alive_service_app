import 'package:alive_service_app/models/user_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerRepositoryProvider = Provider((ref) {
  return DrawerRepository(
      firebaseStorage: FirebaseStorage.instance,
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance);
});

class DrawerRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  DrawerRepository({
    required this.firebaseStorage,
    required this.firestore,
    required this.auth,
  });

  Future<Map<String, List<String>>> userWorkData() async {
    Map<String, List<String>> userIdWorkType = {};
    List<String> workTypeId = [];
    List<String> userData = [];
    String currentUser = auth.currentUser!.uid;
    if (currentUser.isNotEmpty) {
      final querySnapshot = await firestore.collection('userDetails').get();
      for (var snapshot in querySnapshot.docs) {
        final ref = await snapshot.reference.collection('Users').get();
        final userDocument =
            ref.docs.where((element) => element.id == currentUser);
        if (userDocument.isNotEmpty) {
          workTypeId.add(snapshot.id);
        }
      }
      final userMap = await firestore
          .collection('userDetails')
          .doc(workTypeId[0])
          .collection('Users')
          .doc(currentUser)
          .get();
      final data = UserDetail.fromMap(userMap.data() as Map<String, dynamic>);
      userData.add(data.mainImage);
      userData.add(data.shopeName);
      userData.add(data.phoneNumber);
      userIdWorkType['userId'] = [currentUser];
      userIdWorkType['workTypes'] = workTypeId;
      userIdWorkType['userData'] = userData;
    }
    return userIdWorkType;
  }
}
