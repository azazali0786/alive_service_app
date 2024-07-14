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

  Future<Map<String, dynamic>> getWorkerData(
      String workType, String workerId) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('userDetails')
          .doc(workType)
          .collection('Users')
          .doc(workerId)
          .get();
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      return userData;
    } catch (e) {
      throw e.toString();
    }
  }

  void submitRating(Map<String,dynamic> worker, double rating ,String workerId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
// widget.workerInf['workerId']![0]
    DocumentReference workerRef = FirebaseFirestore.instance
        .collection('userDetails')
        .doc(worker['workType']) 
        .collection('Users')
        .doc(workerId);

    DocumentReference userRatingRef = workerRef
        .collection('ratings')
        .doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot workerSnapshot = await transaction.get(workerRef);
      DocumentSnapshot userRatingSnapshot = await transaction.get(userRatingRef);

      if (!workerSnapshot.exists) {
        throw Exception("Worker does not exist!");
      }

      double currentOverallRating = (workerSnapshot['overallRating'] as num).toDouble();
      int currentRatingCount = workerSnapshot['ratingCount'] as int;

      double previousUserRating = 0.0;
      if (userRatingSnapshot.exists) {
        previousUserRating = (userRatingSnapshot['rating'] as num).toDouble();
      }

      double newOverallRating;
      if (userRatingSnapshot.exists) {
        newOverallRating = (currentOverallRating * currentRatingCount - previousUserRating + rating) / currentRatingCount;
      } else {
        newOverallRating = (currentOverallRating * currentRatingCount + rating) / (currentRatingCount + 1);
        currentRatingCount += 1;
      }

      transaction.update(workerRef, {
        'overallRating': newOverallRating,
        'ratingCount': currentRatingCount,
      });

      transaction.set(userRatingRef, {
        'rating': rating,
      });
    });
  }





  Stream<QuerySnapshot> getQuery() {
    return firestore
        .collection('callDetails')
        .doc(auth.currentUser!.uid)
        .collection('callHistory').orderBy('date', descending: false)
        .snapshots();
  }

  void call(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void setCallHistory({
    required BuildContext context,
    required String mainImage,
    required String workerId,
    required String shopeName,
    required String workType,
    required String timeIn,
    required String date,
  }) async {
    try {
      var uniqueId = const Uuid().v4();
      final callDetail = CallDetail(
          mainImage: mainImage,
          shopName: shopeName,
          workerId: workerId,
          workType: workType,
          timeIn: timeIn,
          date: date);
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
