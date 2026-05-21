import 'package:get/get.dart';
import 'package:moeb_26/modules/auth/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SplashScreenController());
  }
}
