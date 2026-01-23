import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/createaccountscreen.dart';
import 'package:moeb_26/Views/auth/signscreen.dart';
import '../Views/auth/Splash_Screen/splashScreen.dart';
import '../Views/auth/resetpassword/resetpasswordscreen.dart';
import '../Views/auth/resetpassword/resetpasswordthree.dart';
import '../Views/auth/resetpassword/resetpasswordtwo.dart';
import '../Views/auth/resetpassword/success_resetpassword.dart';


class Routes {
  static const String splashScreen = "/SplashScreen";
  static const String signscreen = "/Signscreen";
  static const String createaccountscreen = "/Createaccountscreen";
  static const String resetpasswordscreen = "/Resetpasswordscreen";
  static const String resetpasswordtwo = "/Resetpasswordtwo";
  static const String resetpasswordthree = "/Resetpasswordthree";
  static const String successResetpassword = "/SuccessResetpassword";

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => Splashscreen(),transition: Transition.noTransition),
    GetPage(name: signscreen, page: () => Signscreen(),transition: Transition.noTransition),
    GetPage(name: createaccountscreen, page: () => Createaccountscreen(),transition: Transition.noTransition),
    GetPage(name: resetpasswordscreen, page: () => Resetpasswordscreen(),transition: Transition.noTransition),
    GetPage(name: resetpasswordtwo, page: () => Resetpasswordtwo(),transition: Transition.noTransition),
    GetPage(name: resetpasswordthree, page: () => Resetpasswordthree(),transition: Transition.noTransition),
    GetPage(name: successResetpassword, page: () => SuccessResetpassword(),transition: Transition.noTransition),

  ];
}