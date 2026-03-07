import 'dart:io';

import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class MarketplaceRepo {
  final ApiClient apiClient;
  MarketplaceRepo({required this.apiClient});

  Future<Response> getAllItems({
    String? searchTerm,
    String? condition,
    int page = 1,
    int limit = 10,
  }) async {
    final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['searchTerm'] = searchTerm;
    }

    if (condition != null && condition.isNotEmpty) {
      queryParams['condition'] = condition;
    }

    return await apiClient.getData(ApiConstants.items, query: queryParams);
  }

  Future<Response> getMyItems({
    String? searchTerm,
    int page = 1,
    int limit = 10,
    String? sort = '-createdAt',
  }) async {
    final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }

    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['searchTerm'] = searchTerm;
    }

    return await apiClient.getData(ApiConstants.myItems, query: queryParams);
  }

  Future<Response> createItem({
    required String title,
    required String price,
    String? condition,
    required String location,
    String? description,
    List<File>? photos,
  }) async {
    final Map<String, dynamic> body = {
      'title': title,
      'price': price,
      'location': location,
    };

    if (condition != null && condition.isNotEmpty) {
      body['condition'] = condition;
    }

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    final List<MultipartBody> multipartBody = photos != null
        ? photos.map((file) => MultipartBody('photos', file)).toList()
        : [];

    return await apiClient.postMultipartData(
      ApiConstants.items,
      body,
      multipartBody: multipartBody,
    );
  }

  Future<Response> updateItem({
    required String itemId,
    required String title,
    required String price,
    String? condition,
    required String location,
    String? description,
    List<File>? photos, // For new photos
    String? status,
  }) async {
    final Map<String, dynamic> body = {
      'title': title,
      'price': price,
      'location': location,
    };

    if (condition != null && condition.isNotEmpty) {
      body['condition'] = condition;
    }

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    if (status != null && status.isNotEmpty) {
      body['status'] = status;
    }

    final List<MultipartBody> multipartBody =
        photos != null && photos.isNotEmpty
        ? photos.map((file) => MultipartBody('photos', file)).toList()
        : [];

    return await apiClient.patchMultipartData(
      '${ApiConstants.items}/$itemId',
      body,
      multipartBody: multipartBody,
    );
  }

  Future<Response> deleteItem(String itemId) async {
    return await apiClient.deleteData('${ApiConstants.items}/$itemId');
  }
}
