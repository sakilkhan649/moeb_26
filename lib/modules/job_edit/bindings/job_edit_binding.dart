import 'package:get/get.dart';
import 'package:moeb_26/modules/job_edit/controllers/job_edit_controller.dart';

class JobEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobEditController());
  }
}
