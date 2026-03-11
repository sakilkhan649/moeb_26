import 'dart:io';
import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class CommunityRepo {
  final ApiClient apiClient;
  CommunityRepo({required this.apiClient});

  Future<Response> getCommunityRoom() async {
    return await apiClient.getData(ApiConstants.communityRoom);
  }

  Future<Response> getCommunityMessages({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      "${ApiConstants.communityMessages}?page=$page&limit=$limit",
    );
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
            await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
          ),
        );
      }
    }

    return await apiClient.postData(ApiConstants.communityMessages, formData);
  }
}
