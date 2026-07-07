import 'package:get/get.dart';
import 'package:moeb_26/modules/jobs_posts/controllers/job_post_controller.dart';

class JobPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostJobController());
  }
}
