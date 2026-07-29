import 'package:get/get.dart';
import 'package:moeb_26/modules/my_job_progress_details/controllers/my_job_progress_details_controller.dart';

class MyJobProgressDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyJobProgressDetailsController());
  }
}
