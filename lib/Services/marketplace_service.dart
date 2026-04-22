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

  Future<Response> getMyItems({
    String? searchTerm,
    int page = 1,
    int limit = 10,
    String? sort = '-createdAt',
  }) async {
    try {
      return await _marketplaceRepo.getMyItems(
        searchTerm: searchTerm,
        page: page,
        limit: limit,
        sort: sort,
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

  Future<Response> updateItem({
    required String itemId,
    required String title,
    required String price,
    String? condition,
    required String location,
    String? description,
    List<File>? photos,
    String? status,
  }) async {
    try {
      return await _marketplaceRepo.updateItem(
        itemId: itemId,
        title: title,
        price: price,
        condition: condition,
        location: location,
        description: description,
        photos: photos,
        status: status,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteItem(String itemId) async {
    try {
      return await _marketplaceRepo.deleteItem(itemId);
    } catch (e) {
      rethrow;
    }
  }
}
