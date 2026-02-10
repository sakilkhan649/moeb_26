import 'package:get/get.dart';

import '../controller/splashcontroller.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SplashScreenController());
  }
}