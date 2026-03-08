import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../Ripositoryes/user_repository.dart';

class UserService extends GetxService {
  late UserRepo _userRepo;
  final RxString _userId = "".obs;

  String get userId => _userId.value;
  set userId(String value) => _userId.value = value;

  @override
  void onInit() {
    super.onInit();
    _userRepo = UserRepo(apiClient: Get.find());
  }

  Future<UserService> init() async {
    return this;
  }

  // ========== Vehicle only ==========
  Future<Response> updateVehicles({
    required List<Map<String, dynamic>> vehicles,
  }) async {
    try {
      return await _userRepo.updateVehicles(vehicles: vehicles);
    } catch (e) {
      rethrow;
    }
  }

  // ========== Documents only ==========
  Future<Response> updateDocuments({
    required List<Map<String, dynamic>> vehicles, // 👈 যোগ করা হয়েছে
    required File drivingLicense,
    required String drivingLicenseExpire,
    required File hackLicense,
    required String hackLicenseExpire,
    File? localPermit,
    String? localPermitExpire,
    required File commercialInsurance,
    required String commercialInsuranceExpire,
    required File vehicleRegistration,
    required String vehicleRegistrationExpire,
    required File headshot,
    required File frontView,
    required File rearView,
    required File interiorView,
  }) async {
    try {
      return await _userRepo.updateDocuments(
        vehicles: vehicles, // 👈 pass করো
        drivingLicense: drivingLicense,
        drivingLicenseExpire: drivingLicenseExpire,
        hackLicense: hackLicense,
        hackLicenseExpire: hackLicenseExpire,
        localPermit: localPermit,
        localPermitExpire: localPermitExpire,
        commercialInsurance: commercialInsurance,
        commercialInsuranceExpire: commercialInsuranceExpire,
        vehicleRegistration: vehicleRegistration,
        vehicleRegistrationExpire: vehicleRegistrationExpire,
        headshot: headshot,
        frontView: frontView,
        rearView: rearView,
        interiorView: interiorView,
      );
    } catch (e) {
      rethrow;
    }
  }
}
