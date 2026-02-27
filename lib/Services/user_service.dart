import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../Ripositoryes/user_repository.dart';

class UserService extends GetxService {
  late UserRepo _userRepo;

  @override
  void onInit() {
    super.onInit();
    _userRepo = UserRepo(apiClient: Get.find());
  }

  Future<UserService> init() async {
    return this;
  }

  Future<Response> updateProfile({
    required List<Map<String, dynamic>> vehicles,
  }) async {
    try {
      return await _userRepo.updateProfile(vehicles: vehicles);
    } catch (e) {
      rethrow;
    }
  }
}