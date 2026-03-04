import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../Ripositoryes/marketplace_repository.dart';
import 'api_client.dart';

class MarketplaceService extends GetxService {
  late MarketplaceRepo _marketplaceRepo;

  @override
  void onInit() {
    super.onInit();
    _marketplaceRepo = MarketplaceRepo(apiClient: Get.find<ApiClient>());
  }

  Future<Response> getAllItems({
    String? searchTerm,
    String? condition,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _marketplaceRepo.getAllItems(
        searchTerm: searchTerm,
        condition: condition,
        page: page,
        limit: limit,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createItem({
    required String title,
    required String price,
    String? condition,
    required String location,
    String? description,
    List<File>? photos,
  }) async {
    try {
      return await _marketplaceRepo.createItem(
        title: title,
        price: price,
        condition: condition,
        location: location,
        description: description,
        photos: photos,
      );
    } catch (e) {
      rethrow;
    }
  }
}
