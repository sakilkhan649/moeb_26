import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:moeb_26/core/widgets/screens/no_internet_screen.dart';
import 'package:moeb_26/modules/auth/vehicle/views/add_new_vehicle_view.dart';
import 'package:moeb_26/modules/bottom_nab_bar/bindings/bottom_nabbar_binding.dart';
import 'package:moeb_26/modules/service_Area/views/Service_Area_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/all_vehicle_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/application_not_Approved_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/application_submited_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/account_succes_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/change_password_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/create_account_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/documents_upload_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/otp_verifications_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/personal_document_view.dart';
import 'package:moeb_26/modules/auth/profile/views/profile_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/reset_password_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/reset_password_three_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/success_reset_password_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/signin_view.dart';
import 'package:moeb_26/modules/auth/splash/binding/splash_binding.dart';
import 'package:moeb_26/modules/auth/splash/views/splash_view.dart';
import 'package:moeb_26/modules/auth/term_and_policy/views/term_policy.dart';
import 'package:moeb_26/modules/auth/term_and_policy/views/privacy_policy_sign_up.dart';
import 'package:moeb_26/modules/auth/vehicle/views/vehicle_Information_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/auth_selection_view.dart';
import 'package:moeb_26/modules/bottom_nab_bar/views/bottom_nabbar_view.dart';
import 'package:moeb_26/modules/chat_detail/views/chat_detail_view.dart';
import 'package:moeb_26/modules/chat/views/chat_view.dart';
import 'package:moeb_26/modules/chat_community/views/chat_community_detail_view.dart';
import 'package:moeb_26/modules/chat_support_detail/views/chat_support_detail_view.dart';
import 'package:moeb_26/modules/jobs_approve/views/job_approve_view.dart';
import 'package:moeb_26/modules/job_edit/views/job_edit_view.dart';
import 'package:moeb_26/modules/ratings_feedback/views/ratings_feedback_view.dart';
import 'package:moeb_26/modules/ride_progress_way_location/views/ride_progress_way_location_view.dart';
import 'package:moeb_26/modules/my_jobs/views/my_jobs_view.dart';
import 'package:moeb_26/modules/request_submitted/views/request_submitted_view.dart';
import 'package:moeb_26/modules/my_items/views/my_Items_view.dart';
import 'package:moeb_26/modules/request_under_review/views/request_under_review_view.dart';
import 'package:moeb_26/modules/ride_completed/views/ride_completed_view.dart';
import 'package:moeb_26/modules/ride_details/views/ride_details_view.dart';

class Routes {
  static const String splashScreen = "/SplashScreen";
  static const String createscreens = "/Createscreens";
  static const String signscreen = "/Signscreen";
  static const String createaccountscreen = "/Createaccountscreen";
  static const String resetpasswordscreen = "/Resetpasswordscreen";
  //static const String resetpasswordtwo = "/Resetpasswordtwo";
  static const String resetpasswordthree = "/Resetpasswordthree";
  static const String successResetpassword = "/SuccessResetpassword";
  static const String vehicleinformation = "/Vehicleinformation";
  static const String documentsupload = "/Documentsupload";
  static const String termPolicy = "/TermPolicy";
  static const String applicationSubmited = "/ApplicationSubmited";
  static const String applicationNotApproved = "/ApplicationNotApproved";
  static const String homeScreens = "/HomeScreens";
  static const String myJobsScreen = "/MyJobsScreen";
  static const String editScreen = "/EditScreen";
  static const String accountSuccesScreen = "/AccountSuccesScreen";
  static const String requestSubmitted = "/RequestSubmitted";
  static const String requestUnderReview = "/RequestUnderReview";
  static const String chatPage = "/Chatpage";
  static const String chatDetailPage = "/ChatDetailPage";
  static const String communityChatDetailPage = "/CommunityChatDetailPage";
  static const String rideDetailsPage = "/RideDetailsPage";
  // static const String onMyWayDetailsPage = "/OnMyWayDetailsPage";
  // static const String pobDetailsPage = "/PobDetailsPage";
  // static const String finishRidePage = "/FinishRidePage";
  static const String rideCompletedPage = "/RideCompletedPage";
  static const String approvePage = "/ApprovePage";
  static const String rideProgressWay = "/RideProgressWay";
  static const String rideProgressWayLocation = "/RideProgressWayLocation";
  static const String rideProgressBoard = "/RideProgressBoard";
  static const String rideCompleteJob = "/RideCompleteJob";
  static const String profileScreen = "/ProfileScreen";
  static const String ratingsFeedback = "/RatingsFeedback";
  static const String serviceArea = "/ServiceArea";
  static const String noInternetScreen = "/NoInternetScreen";
  static const String otpVerificationScreen = "/OtpVerificationScreen";
  static const String forgetotpVerificationScreen = "/OtpVerificationScreen";
  static const String changePasswordScreen = "/ChangePasswordScreen";
  static const String myPropucts = "/MyPropucts";
  static const String supportChatDetailPage = "/SupportChatDetailPage";
  static const String privacyPolicySignUp = "/PrivacyPolicySignUp";
  static const String allVehicle = "/AllVehicle";
  static const String addNewVehicle = "/AddNewVehicle";
  static const String personalDocument = "/PersonalDocument";

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => Splashscreen(),
      transition: Transition.noTransition,
      binding: SplashBinding(),
    ),
    GetPage(
      name: privacyPolicySignUp,
      page: () => PrivacyPolicySignUp(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: createscreens,
      page: () => Createscreens(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: signscreen,
      page: () => Signscreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: createaccountscreen,
      page: () => Createaccountscreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: resetpasswordscreen,
      page: () => Resetpasswordscreen(),
      transition: Transition.noTransition,
    ),
    // GetPage(
    //   name: resetpasswordtwo,
    //   page: () => Resetpasswordtwo(),
    //   transition: Transition.noTransition,
    // ),
    GetPage(
      name: resetpasswordthree,
      page: () => Resetpasswordthree(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: successResetpassword,
      page: () => SuccessResetpassword(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: vehicleinformation,
      page: () => Vehicleinformation(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: documentsupload,
      page: () => Documentsupload(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: termPolicy,
      page: () => TermPolicy(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: applicationSubmited,
      page: () => ApplicationSubmited(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: applicationNotApproved,
      page: () => ApplicationNotApproved(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: homeScreens,
      page: () => HomeScreens(),
      transition: Transition.noTransition,
      binding: BottomNabbarBinding(),
    ),
    GetPage(
      name: myJobsScreen,
      page: () => MyJobsScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: editScreen,
      page: () => EditScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: accountSuccesScreen,
      page: () => AccountSuccesScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: requestSubmitted,
      page: () => RequestSubmitted(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: requestUnderReview,
      page: () => RequestUnderReview(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: chatPage,
      page: () => Chatpage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: chatDetailPage,
      page: () => ChatDetailPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: communityChatDetailPage,
      page: () => CommunityChatDetailPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: rideDetailsPage,
      page: () => RideDetailsPage(),
      transition: Transition.noTransition,
    ),
    // GetPage(
    //   name: onMyWayDetailsPage,
    //   page: () => OnMyWayDetailsPage(),
    //   transition: Transition.noTransition,
    // ),
    // GetPage(
    //   name: pobDetailsPage,
    //   page: () => PobDetailsPage(),
    //   transition: Transition.noTransition,
    // ),
    // GetPage(
    //   name: finishRidePage,
    //   page: () => FinishRidePage(),
    //   transition: Transition.noTransition,
    // ),
    GetPage(
      name: rideCompletedPage,
      page: () => RideCompletedPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: approvePage,
      page: () => ApprovePage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: rideProgressWayLocation,
      page: () => RideProgressWayLocation(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: profileScreen,
      page: () => ProfileScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: ratingsFeedback,
      page: () => RatingsFeedback(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: serviceArea,
      page: () => ServiceArea(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: noInternetScreen,
      page: () => NoInternetScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: otpVerificationScreen,
      page: () => OtpVerificationScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: forgetotpVerificationScreen,
      page: () => OtpVerificationScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: changePasswordScreen,
      page: () => ChangePasswordScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: myPropucts,
      page: () => MyItems(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: supportChatDetailPage,
      page: () => SupportChatDetailPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: allVehicle,
      page: () => AllVehicle(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: addNewVehicle,
      page: () => AddNewVehicle(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: personalDocument,
      page: () => PersonalDocument(),
      transition: Transition.noTransition,
    ),
  ];
}
