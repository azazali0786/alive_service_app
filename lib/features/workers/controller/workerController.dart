// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alive_service_app/models/user_detail_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alive_service_app/features/workers/repository/workerRepository.dart';

final workerControllerProvidere = Provider((ref) {
  final workerRepository = ref.watch(workerRepositoryProvider);
  return WorkerController(workerRepository: workerRepository);
});

class WorkerController {
  final WorkerRepository workerRepository;
  WorkerController({
    required this.workerRepository,
  });

  Stream<List<UserDetail>> getWorkerData(String workType) {
    return workerRepository.getWorkerData(workType);
  }
}
