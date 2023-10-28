import 'package:alive_service_app/models/user_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Stream<List<UserDetail>> getWorkerData(String workType) {
    return firestore
        .collection('userDetails')
        .doc(workType)
        .collection('Users')
        .snapshots()
        .map((event) {
      List<UserDetail> workersDatalist = [];
      for (var workers in event.docs) {
        workersDatalist.add(UserDetail.fromMap(workers.data()));
      }
      return workersDatalist;
    });
  }
}
