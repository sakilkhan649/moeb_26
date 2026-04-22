import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../Ripositoryes/support_repository.dart';

class SupportService extends GetxService {
  late SupportRepo _supportRepo;

  @override
  void onInit() {
    super.onInit();
    _supportRepo = SupportRepo(apiClient: Get.find());
  }

  Future<Response> getMyTickets() async {
    try {
      return await _supportRepo.getMyTickets();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createSupport({
    required String subject,
    required String message,
  }) async {
    try {
      return await _supportRepo.createSupport(
        subject: subject,
        message: message,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getMessages(String chatId) async {
    try {
      return await _supportRepo.getMessages(chatId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendMessage(String chatId, String message) async {
    try {
      return await _supportRepo.sendMessage(chatId, message);
    } catch (e) {
      rethrow;
    }
  }
}
