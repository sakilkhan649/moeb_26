import 'package:get/get.dart';
import '../controllers/meet_greet_controller.dart';

class MeetGreetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetGreetController>(() => MeetGreetController());
  }
}
