import 'package:alive_service_app/features/workers/repository/workerRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workerControllerProvidere = Provider((ref) {
  final workerRepository = ref.watch(workerRepositoryProvider);
  return WorkerController(workerRepository: workerRepository);
});

class WorkerController {
  final WorkerRepository workerRepository;
  WorkerController({
    required this.workerRepository,
  });

  // Future<Map<String,dynamic>> getWorkerData(String workType, String workerId) {
  //   return workerRepository.getWorkerData(workType, workerId);
  // }

  Stream<QuerySnapshot> getQuery() {
    return workerRepository.getQuery();
  }
}