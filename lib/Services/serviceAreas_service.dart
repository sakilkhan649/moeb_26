import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../Ripositoryes/serviceAreas_repository.dart';
import 'api_client.dart';

class ServiceAreasService extends GetxService {
  late ServiceAreasRepo _serviceAreasRepo;

  @override
  void onInit() {
    super.onInit();
    _serviceAreasRepo = ServiceAreasRepo(apiClient: Get.find<ApiClient>());
  }

  Future<Response> getAllServiceAreas() async {
    try {
      return await _serviceAreasRepo.getAllServiceAreas();
    } catch (e) {
      rethrow;
    }
  }
}
