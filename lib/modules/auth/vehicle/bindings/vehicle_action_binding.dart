import 'package:get/get.dart';
import 'package:moeb_26/modules/auth/vehicle/controllers/vehicle_action_controller.dart';

class VehicleActionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => VehicleActionController(),
      tag: "vehicleActionController",
    );
  }
}
