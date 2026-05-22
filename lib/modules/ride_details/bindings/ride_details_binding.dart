import 'package:get/get.dart';
import 'package:moeb_26/modules/ride_details/controllers/ride_details_controller.dart';

class RideDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RideDetailsController());
  }
}
