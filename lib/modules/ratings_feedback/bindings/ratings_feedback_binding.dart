import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:moeb_26/modules/ratings_feedback/controllers/ratings_feedback_controller.dart';

class RatingsFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RatingsFeedbackController());
  }
}
