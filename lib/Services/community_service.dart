import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../Ripositoryes/community_repository.dart';

class CommunityService extends GetxService {
  late CommunityRepo _communityRepo;

  @override
  void onInit() {
    super.onInit();
    _communityRepo = CommunityRepo(apiClient: Get.find());
  }

  Future<Response> getCommunityRoom() async {
    try {
      return await _communityRepo.getCommunityRoom();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCommunityMessages({int page = 1, int limit = 10}) async {
    try {
      return await _communityRepo.getCommunityMessages(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendCommunityMessage({
    required String text,
    List<File>? attachments,
  }) async {
    try {
      return await _communityRepo.sendCommunityMessage(
        text: text,
        attachments: attachments,
      );
    } catch (e) {
      rethrow;
    }
  }
}
