import 'package:get/get.dart';
import 'package:moeb_26/modules/service_Area/controllers/serviceController.dart';

class ServiceAreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceAreaController());
  }
}
