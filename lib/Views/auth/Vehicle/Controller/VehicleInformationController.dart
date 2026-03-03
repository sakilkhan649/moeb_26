import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import '../Model/VehicleModel.dart';

class VehicleInformationController extends GetxController {
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
    // Build vehicles list
    final vehicleData = vehicles.map((v) => v.toJson()).toList();

    // Save to SignupController (no API call here)
    final signupCtrl = Get.find<SignupController>();
    signupCtrl.saveVehicles(vehicleData);

    // Navigate to next step
    Get.toNamed(Routes.documentsupload);
  }

  @override
  void onClose() {
    for (var vehicle in vehicles) {
      vehicle.dispose();
    }
    super.onClose();
  }
}
