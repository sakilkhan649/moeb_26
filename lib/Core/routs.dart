import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/VehicleInformation.dart';
import 'package:moeb_26/Views/auth/createaccountscreen.dart';
import 'package:moeb_26/Views/auth/signscreen.dart';
import 'package:moeb_26/Views/home/JobOfferPage/My_jobs/my_jobs.dart';
import '../Views/auth/Account_succes_screen.dart';
import '../Views/auth/Application_Not_Approved.dart';
import '../Views/auth/Application_submited.dart';
import '../Views/auth/DocumentsUpload.dart';
import '../Views/auth/Splash_Screen/splashScreen.dart';
import '../Views/auth/Term_policy.dart';
import '../Views/auth/resetpassword/resetpasswordscreen.dart';
import '../Views/auth/resetpassword/resetpasswordthree.dart';
import '../Views/auth/resetpassword/resetpasswordtwo.dart';
import '../Views/auth/resetpassword/success_resetpassword.dart';
import '../Views/home/JobOfferPage/My_jobs/edit_screen.dart';
import '../Views/home/JobOfferPage/Request_Submitted/Request_Submitted.dart';
import '../Views/home/RidesPage/Request_Under_review.dart';
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

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => Splashscreen(),transition: Transition.noTransition),
    GetPage(name: signscreen, page: () => Signscreen(),transition: Transition.noTransition),
    GetPage(name: createaccountscreen, page: () => Createaccountscreen(),transition: Transition.noTransition),
    GetPage(name: resetpasswordscreen, page: () => Resetpasswordscreen(),transition: Transition.noTransition),
    GetPage(name: resetpasswordtwo, page: () => Resetpasswordtwo(),transition: Transition.noTransition),
    GetPage(name: resetpasswordthree, page: () => Resetpasswordthree(),transition: Transition.noTransition),
    GetPage(name: successResetpassword, page: () => SuccessResetpassword(),transition: Transition.noTransition),
    GetPage(name: vehicleinformation, page: () => Vehicleinformation(),transition: Transition.noTransition),
    GetPage(name: documentsupload, page: () => Documentsupload(),transition: Transition.noTransition),
    GetPage(name: termPolicy, page: () => TermPolicy(),transition: Transition.noTransition),
    GetPage(name: applicationSubmited, page: () => ApplicationSubmited(),transition: Transition.noTransition),
    GetPage(name: applicationNotApproved, page: () => ApplicationNotApproved(),transition: Transition.noTransition),
    GetPage(name: homeScreens, page: () => HomeScreens(),transition: Transition.noTransition),
    GetPage(name: myJobsScreen, page: () => MyJobsScreen(),transition: Transition.noTransition),
    GetPage(name: editScreen, page: () => EditScreen(),transition: Transition.noTransition),
    GetPage(name: accountSuccesScreen, page: () => AccountSuccesScreen(),transition: Transition.noTransition),
    GetPage(name: requestSubmitted, page: () => RequestSubmitted(),transition: Transition.noTransition),
    GetPage(name: requestUnderReview, page: () => RequestUnderReview(),transition: Transition.noTransition),

  ];
}