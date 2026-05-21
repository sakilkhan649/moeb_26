import 'package:get/get.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/change_pass_controller.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/forget_password_controller.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/otp_verification_controller.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/personal_document_controller.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/reset_password_controller.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/signin_controller.dart';
import 'package:moeb_26/modules/auth/authentication/controllers/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordController());
    Get.lazyPut(() => SignupController());
    Get.lazyPut(() => OtpController());
    Get.lazyPut(() => PersonalDocumentController());
    Get.lazyPut(() => ResetPasswordController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => LoginController());
  }
}
