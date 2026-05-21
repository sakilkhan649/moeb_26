import 'package:get/get.dart';
import 'package:moeb_26/modules/my_jobs/controllers/my_jobs_controller.dart';

class MyJobsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingController());
  }
}
