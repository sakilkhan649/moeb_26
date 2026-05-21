import 'package:get/get.dart';
import 'package:moeb_26/core/controllers/internet_controller.dart';
import 'package:moeb_26/modules/auth/splash/controller/splash_controller.dart';
import 'package:moeb_26/modules/bottom_nab_bar/controllers/bottom_nabbar_controller.dart';
import 'package:moeb_26/modules/chat/controllers/chat_controller.dart';
import 'package:moeb_26/modules/my_jobs/controllers/my_jobs_controller.dart';
import 'package:moeb_26/modules/rides/controllers/rides_controller.dart';
import 'package:moeb_26/data/repositories/auth_reporitory.dart';
import 'package:moeb_26/data/repositories/community_repository.dart';
import 'package:moeb_26/data/repositories/job_repository.dart';
import 'package:moeb_26/data/repositories/ratings_feedback_repository.dart';
import 'package:moeb_26/data/repositories/socket_repository.dart';
import 'package:moeb_26/data/repositories/support_repository.dart';
import 'package:moeb_26/data/repositories/user_profile_repository.dart';
import 'package:moeb_26/data/repositories/user_repository.dart';
import 'package:moeb_26/core/services/api_client.dart';
import 'package:moeb_26/core/services/auth_service.dart';
import 'package:moeb_26/core/services/job_service.dart';
import 'package:moeb_26/core/services/storege_service.dart';
import 'package:moeb_26/core/services/socket_service.dart';
import 'package:moeb_26/core/services/user_profile_service.dart';
import 'package:moeb_26/core/services/ratings_feedback_service.dart';
import 'package:moeb_26/core/services/user_service.dart';
import 'package:moeb_26/core/services/support_service.dart';
import 'package:moeb_26/core/services/community_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InternetController(), permanent: true);
    Get.put(ApiClient(), permanent: true);
    Get.put(StorageService(), permanent: true);

    // Repos আগে
    Get.put(AuthRepo(apiClient: Get.find()), permanent: true);
    Get.put(UserRepo(apiClient: Get.find()), permanent: true); // 👈 যোগ করো
    Get.put(UserProfileRepo(apiClient: Get.find()), permanent: true);
    Get.put(JobRepo(apiClient: Get.find()), permanent: true);
    Get.put(RatingsFeedbackRepo(apiClient: Get.find()), permanent: true);
    Get.put(SocketRepository(apiClient: Get.find()), permanent: true);
    Get.put(SupportRepo(apiClient: Get.find()), permanent: true);
    Get.put(CommunityRepo(apiClient: Get.find()), permanent: true);

    // services পরে
    Get.put(UserService(), permanent: true); // 👈 AuthService এর আগে দাও
    Get.put(SocketService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(SupportService(), permanent: true);
    Get.put(CommunityService(), permanent: true);
    Get.put(UserProfileService(userProfileRepo: Get.find()), permanent: true);
    Get.put(JobService(), permanent: true);
    Get.put(
      RatingsFeedbackService(ratingsFeedbackRepo: Get.find()),
      permanent: true,
    );

    Get.lazyPut(() => SplashScreenController());

    // Controllers
    Get.lazyPut(() => NavigationController());
    Get.lazyPut(() => BookingController());
    Get.lazyPut(() => RidesController());
    Get.lazyPut(() => ChatController());
  }
}
