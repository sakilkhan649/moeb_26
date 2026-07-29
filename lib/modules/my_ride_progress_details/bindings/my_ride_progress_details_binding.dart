import 'package:get/get.dart';
import 'package:moeb_26/modules/my_ride_progress_details/controllers/my_ride_progress_details_controller.dart';

class MyRideProgressDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyRideProgressDetailsController());
  }
}
