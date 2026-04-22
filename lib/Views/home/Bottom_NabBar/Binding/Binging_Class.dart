import 'package:get/get.dart';
import '../../ChatPage/Controller/Chat_controller.dart';
import '../../DealsPage/Controller/Deals_controller.dart';
import '../../JobOfferPage/My_jobs/Controller/My_job_controller.dart';
import '../../MarketplacePage/Controller/Marketplace_controller.dart';
import '../../RidesPage/Controller/Rides_controller.dart';
import '../Controller/bottom_nabbar_controller.dart';


class BottomNabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
    Get.lazyPut(() => RidesController());
    Get.lazyPut(() => BookingController());
    Get.lazyPut(() => MarketplaceController());
    Get.lazyPut(() => DealsController());
    Get.lazyPut(() => ChatController());
  }
}
