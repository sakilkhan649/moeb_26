import 'package:get/get.dart';
import 'package:moeb_26/modules/service_area/Controllers/serviceController.dart';

class ServiceAreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceAreaController());
  }
}
