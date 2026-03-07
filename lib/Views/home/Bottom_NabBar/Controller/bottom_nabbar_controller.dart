import 'package:get/get.dart';
import '../../RidesPage/Controller/Rides_controller.dart';
import '../../JobOfferPage/My_jobs/Controller/My_job_controller.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is int) {
      currentIndex.value = Get.arguments;
    } else if (Get.arguments is Map &&
        Get.arguments.containsKey('bottomIndex')) {
      currentIndex.value = Get.arguments['bottomIndex'];
    }
  }

  void changeIndex(int index) {
    currentIndex.value = index;
    if (index == 0) { // Index 0 is JobOfferPage
      if (Get.isRegistered<BookingController>()) {
        Get.find<BookingController>().fetchJobOffers(isRefresh: true);
      }
    } else if (index == 1) { // Index 1 is RidesPage
      if (Get.isRegistered<RidesController>()) {
        Get.find<RidesController>().refreshCurrentTab();
      }
    }
  }
}
