import 'package:get/get.dart';
import '../../Controller/internet_controller.dart';
import '../../Services/api_client.dart';
import '../../Services/auth_service.dart';
import '../../Services/storege_service.dart';
import '../../Views/auth/Splash_Screen/controller/splashcontroller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetController(), permanent: true);
    Get.put(ApiClient(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(StorageService(), permanent: true);
    Get.lazyPut(() => SplashScreenController());
  }
}
