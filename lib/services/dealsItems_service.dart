import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import '../Ripositoryes/dealsItems_repository.dart';
import 'api_client.dart';

class DealsService extends GetxService {
  late DealsRepo _dealsRepo;

  @override
  void onInit() {
    super.onInit();
    _dealsRepo = DealsRepo(apiClient: Get.find<ApiClient>());
  }

  Future<Response> getActiveDeals({int page = 1, int limit = 10}) async {
    try {
      return await _dealsRepo.getActiveDeals(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }
}
