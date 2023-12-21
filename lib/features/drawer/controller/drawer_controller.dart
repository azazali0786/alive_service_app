import 'package:alive_service_app/features/drawer/repository/drawer_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerControllerProvider = Provider((ref) {
  final drawerRepository = ref.watch(drawerRepositoryProvider);
  return DrawerController(drawerRepository: drawerRepository);
});

class DrawerController {
  final DrawerRepository drawerRepository;
  DrawerController({required this.drawerRepository});

  Future<Map<String, List<String>>> userWorkData() {
    return drawerRepository.userWorkData();
  }
}
