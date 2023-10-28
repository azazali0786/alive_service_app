// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alive_service_app/features/callHistory/repository/callRepository.dart';

final callHistoryControllerProvider = Provider((ref) {
  final callHistoryRepository = ref.watch(callHistoryRepositoryProvider);
  return CallHistoryController(callHistoryRepository: callHistoryRepository);
});

class CallHistoryController {
  final CallHistoryRepository callHistoryRepository;
  CallHistoryController({
    required this.callHistoryRepository,
  });


  
}
