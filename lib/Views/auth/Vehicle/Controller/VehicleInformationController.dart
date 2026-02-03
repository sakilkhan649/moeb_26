import 'package:get/get.dart';
import '../Model/VehicleModel.dart';

class VehicleInformationController extends GetxController {
  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Start with one vehicle card
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

  @override
  void onClose() {
    for (var vehicle in vehicles) {
      vehicle.dispose();
    }
    super.onClose();
  }
}
