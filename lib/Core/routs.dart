import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/Vehicle/VehicleInformation.dart';
import 'package:moeb_26/Views/auth/CreateAccount/createaccountscreen.dart';
import 'package:moeb_26/Views/home/JobOfferPage/My_jobs/my_jobs.dart';
import '../Views/Service_Area/Service_Area.dart';
import '../Views/auth/Application_Succes/Account_succes_screen.dart';
import '../Views/auth/Application_Not_Approved/Application_Not_Approved.dart';
import '../Views/auth/Application_Submitted/Application_submited.dart';
import '../Views/auth/Documents_Upload/DocumentsUpload.dart';
import '../Views/auth/Profile/profile.dart';
import '../Views/auth/Sign_In/signscreen.dart';
import '../Views/auth/Splash_Screen/splashScreen.dart';
import '../Views/auth/Term_and_policy/Term_policy.dart';
import '../Views/auth/resetpassword/resetpasswordscreen.dart';
import '../Views/auth/resetpassword/resetpasswordthree.dart';
import '../Views/auth/resetpassword/resetpasswordtwo.dart';
import '../Views/auth/resetpassword/success_resetpassword.dart';
import '../Views/home/JobOfferPage/My_jobs/Approve/approve_page.dart';
import '../Views/home/JobOfferPage/My_jobs/Ratings_Feedback/Ratings_Feedback.dart';
import '../Views/home/JobOfferPage/My_jobs/Ride_Complete_Job/Ride_Complete_Job.dart';
import '../Views/home/JobOfferPage/My_jobs/Ride_Progress_Board/Ride_Progress_Board.dart';
import '../Views/home/JobOfferPage/My_jobs/Ride_Progress_Way/Ride_Progress_Way.dart';
import '../Views/home/JobOfferPage/My_jobs/Ride_Progress_Way_Location/Ride_Progress_Way_Location.dart';
import '../Views/home/JobOfferPage/My_jobs/Edit_screen/edit_screen.dart';
import '../Views/home/JobOfferPage/Request_Submitted/Request_Submitted.dart';
import '../Views/home/RidesPage/Finish_Ride/Finish_Ride_page.dart';
import '../Views/home/RidesPage/On_My_Way_Details_page/On_My_Way_Details_page.dart';
import '../Views/home/RidesPage/Pob_Details_page/Pob_Details_page.dart';
import '../Views/home/RidesPage/Request_Under_review.dart';
import '../Views/home/ChatPage/ChatPage.dart';
import '../Views/home/ChatPage/ChatDetailPage.dart';
import '../Views/home/RidesPage/Ride_Completed/Ride_Completed_page.dart';
import '../Views/home/RidesPage/Ride_Details/Ride_Details_Page.dart';
import '../Views/home/home_screens.dart';

class Routes {
  static const String splashScreen = "/SplashScreen";
  static const String signscreen = "/Signscreen";
  static const String createaccountscreen = "/Createaccountscreen";
  static const String resetpasswordscreen = "/Resetpasswordscreen";
  static const String resetpasswordtwo = "/Resetpasswordtwo";
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
  static const String rideDetailsPage = "/RideDetailsPage";
  static const String onMyWayDetailsPage = "/OnMyWayDetailsPage";
  static const String pobDetailsPage = "/PobDetailsPage";
  static const String finishRidePage = "/FinishRidePage";
  static const String rideCompletedPage = "/RideCompletedPage";
  static const String approvePage = "/ApprovePage";
  static const String rideProgressWay = "/RideProgressWay";
  static const String rideProgressWayLocation = "/RideProgressWayLocation";
  static const String rideProgressBoard = "/RideProgressBoard";
  static const String rideCompleteJob = "/RideCompleteJob";
  static const String profileScreen = "/ProfileScreen";
  static const String ratingsFeedback= "/RatingsFeedback";
  static const String serviceArea= "/ServiceArea";

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => Splashscreen(),
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
    GetPage(
      name: resetpasswordtwo,
      page: () => Resetpasswordtwo(),
      transition: Transition.noTransition,
    ),
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
      name: rideDetailsPage,
      page: () => RideDetailsPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: onMyWayDetailsPage,
      page: () => OnMyWayDetailsPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: pobDetailsPage,
      page: () => PobDetailsPage(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: finishRidePage,
      page: () => FinishRidePage(),
      transition: Transition.noTransition,
    ),
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
      name: rideProgressWay,
      page: () => RideProgressWay(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: rideProgressWayLocation,
      page: () => RideProgressWayLocation(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: rideProgressBoard,
      page: () => RideProgressBoard(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: rideCompleteJob,
      page: () => RideCompleteJob(),
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
  ];
}
