import 'package:get/get.dart';
import '../../rides/controllers/rides_controller.dart';
import '../../my_jobs/controllers/my_jobs_controller.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../deals/controllers/deals_controller.dart';

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
    if (index == 0) {
      // Index 0 is JobOfferPage
      try {
        Get.find<BookingController>().fetchJobOffers(isRefresh: true);
      } catch (_) {}
    } else if (index == 1) {
      // Index 1 is RidesPage
      try {
        Get.find<RidesController>().refreshCurrentTab();
      } catch (_) {}
    } else if (index == 2) {
      // Index 2 is ChatPage
      try {
        Get.find<ChatController>().fetchChats();
      } catch (_) {}
    } else if (index == 4) {
      // Index 4 is DealsPage
      try {
        if (Get.isRegistered<DealsController>()) {
          Get.find<DealsController>().fetchDeals();
        }
      } catch (_) {}
    }
  }
}
