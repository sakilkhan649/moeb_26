import 'package:get/get.dart';
import 'package:moeb_26/modules/ride_completed/controllers/ride_completed_controller.dart';

class RideCompletedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RideCompletedController());
  }
}
