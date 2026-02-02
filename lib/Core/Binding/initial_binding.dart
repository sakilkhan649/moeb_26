import 'package:get/get.dart';

import '../../Views/auth/Splash_Screen/controller/splashcontroller.dart';

class InitialBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SplashScreenController());

  }
}