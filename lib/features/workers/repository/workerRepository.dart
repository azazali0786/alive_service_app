import 'package:alive_service_app/common/utils/utils.dart';
import 'package:alive_service_app/models/call_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final workerRepositoryProvider = Provider((ref) {
  return WorkerRepository(
      firebaseStorage: FirebaseStorage.instance,
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance);
});

class WorkerRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  WorkerRepository({
    required this.firebaseStorage,
    required this.firestore,
    required this.auth,
  });

  // Future<Map<String, dynamic>> getWorkerData(String workType, String workerId) async {
  //     Map<String, dynamic> specificMap = {};
  //      DocumentSnapshot documentSnapshot =await firestore
  //       .collection('userDetails')
  //       .doc(workType)
  //       .collection('Users')
  //       .doc('workerId')
  //       .get();
  //     if (documentSnapshot.exists) {
  //       return documentSnapshot.data() as Map<String, dynamic>;
  //     } else {
  //        return specificMap = {};
  //     }
  // }

  Stream<QuerySnapshot> getQuery() {
    return firestore
        .collection('callDetails')
        .doc(auth.currentUser!.uid)
        .collection('callHistory')
        .snapshots();
  }

  void call(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void setCallHistory({
    required BuildContext context,
    required String workerId,
    required String shopeName,
    required String workType,
    required String timeIn,
    required String date,
  }) async {
    try {
      var uniqueId = const Uuid().v4();
      final callDetail = CallDetail(
          workerId: workerId, workType: workType, timeIn: timeIn, date: date);
      await firestore
          .collection('callDetails')
          .doc(auth.currentUser!.uid)
          .collection('callHistory')
          .doc(uniqueId)
          .set(callDetail.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  
}
