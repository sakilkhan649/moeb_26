import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/user_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;
import '../Model/VehicleModel.dart';

class VehicleInformationController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    addVehicle();
  }

  void addVehicle() {
    vehicles.add(VehicleModel());
  }

  void removeVehicle(int index) {
    if (vehicles.length > 1) {
      vehicles[index].dispose();
      vehicles.removeAt(index);
    }
  }

  Future<void> submitVehicles() async {
    try {
      isLoading.value = true;

      final vehicleData = vehicles.map((v) => v.toJson()).toList();

      final response = await _userService.updateProfile(
        vehicles: vehicleData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Vehicle information saved', isError: false);
        Get.offAllNamed(Routes.documentsupload); // 👈 next route
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Something went wrong.')
            : 'Something went wrong.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Something went wrong.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (var vehicle in vehicles) {
      vehicle.dispose();
    }
    super.onClose();
  }
}