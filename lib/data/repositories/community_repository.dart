import 'dart:io';
import 'package:dio/dio.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';

class CommunityRepo {
  final ApiClient apiClient;
  CommunityRepo({required this.apiClient});

  Future<Response> getCommunityRoom() async {
    return await apiClient.getData(ApiConstants.communityRoom);
  }

  Future<Response> getCommunityMessages({
    int? page,
    int limit = 40,
    String? serviceArea,
    String? cursor,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (page != null) query['page'] = page;
    if (cursor != null && cursor.isNotEmpty) query['cursor'] = cursor;
    if (serviceArea != null && serviceArea.isNotEmpty) {
      query['serviceArea'] = serviceArea;
    }
    return await apiClient.getData(ApiConstants.communityMessages, query: query);
  }

  Future<Response> sendCommunityMessage({
    required String text,
    List<File>? attachments,
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('text', text));

    if (attachments != null && attachments.isNotEmpty) {
      for (var file in attachments) {
        formData.files.add(
          MapEntry(
            'attachments',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    return await apiClient.postData(ApiConstants.communityMessages, formData);
  }
}
