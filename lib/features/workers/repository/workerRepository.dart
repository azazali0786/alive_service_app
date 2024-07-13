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

  Future<void> rateWorker(String workerId, double rating) async {
  try {
    // Reference to your workers collection in Firestore
    CollectionReference workersRef =
        FirebaseFirestore.instance.collection('workers');

    // Get the current worker document
    DocumentSnapshot workerSnapshot = await workersRef.doc(workerId).get();

    // Ensure worker data is of type Map<String, dynamic>
    Map<String, dynamic>? workerData = workerSnapshot.data() as Map<String, dynamic>?;

    if (workerData != null) {
      // Calculate new average rating
      int currentRatingsCount = workerData['ratingsCount'] ?? 0;
      double currentTotalRatings = workerData['totalRatings'] ?? 0.0;

      // Increment ratings count and add new rating to total
      int newRatingsCount = currentRatingsCount + 1;
      double newTotalRatings = currentTotalRatings + rating;

      // Calculate new average rating
      double newAverageRating = newTotalRatings / newRatingsCount;

      // Update the worker's ratings fields
      await workersRef.doc(workerId).update({
        'rating': newAverageRating,
        'ratingsCount': newRatingsCount,
        'totalRatings': newTotalRatings,
      });

      // Print success message
      print('Worker rated successfully');
    } else {
      throw 'Worker data not found';
    }
  } catch (e) {
    // Print any errors that occur
    print('Error rating worker: $e');
    // Optionally, throw the error or handle it in your UI
    throw e;
  }
}

Future<void> updateRating(String workType, String workerId, double newRating) async {
    try {
      await firestore
          .collection('userDetails')
          .doc(workType)
          .collection('Users')
          .doc(workerId)
          .update({'rating': newRating});
    } catch (e) {
      print('Error updating rating: $e');
      throw e; // Optionally, you can handle the error more gracefully
    }
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
