
import 'package:dio/src/response.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';


class AuthRepo {
  final ApiClient apiClient;
  AuthRepo({required this.apiClient});



  // Future<String> getDeviceId() async {
  //   final deviceInfo = DeviceInfoPlugin();
  //
  //   if (Platform.isAndroid) {
  //     final androidInfo = await deviceInfo.androidInfo;
  //     return androidInfo.id; // অথবা androidInfo.device, androidInfo.model
  //   } else if (Platform.isIOS) {
  //     final iosInfo = await deviceInfo.iosInfo;
  //     return iosInfo.identifierForVendor ?? "unknown";
  //   } else {
  //     return "unsupported";
  //   }
  // }



  /// ===================== SIGNUP =====================
  Future<Response<dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String home,
    required String serviceArea,
    required int experience,
    required String company,
    required String companyRole,
  }) async {
    return await apiClient.postData(ApiConstants.signup, {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "home": home,
      "serviceArea": serviceArea,
      "experience": experience,
      "company": company,
      "companyRole": companyRole,
    });
  }

  /// ===================== LOGIN =====================
  Future<Response> login({
    required String email,
    required String password,
    String? deviceToken,
  }) async {
    return await apiClient.postData(ApiConstants.login, {
      "email": email,
      "password": password,
      "deviceToken": deviceToken ?? '',
    });
  }

  /// ===================== FORGOT PASSWORD =====================
  Future<Response> forgotPassword({required String email}) async {
    return await apiClient.postData(ApiConstants.forgotPassword, {
      "email": email,
    });
  }

  /// ===================== RESEND OTP =====================
  Future<Response> resentOtp({required String email}) async {
    return await apiClient.postData(ApiConstants.resendVerifyEmail, {
      "email": email,
    });
  }

  /// ===================== OTP VERIFY =====================
  Future<Response> otpVerify({
    required String email,
    required int oneTimeCode,
  }) async {
    return await apiClient.postData(ApiConstants.verifyEmail, {
      "email": email,
      "oneTimeCode": oneTimeCode,
    });
  }

  // /// ===================== RESET PASSWORD =====================
  // Future<Response> resetPassword({
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   return await apiClient.postData(ApiConstants.resetPassword, {
  //     "newPassword": newPassword,
  //     "confirmPassword": confirmPassword,
  //   });
  // }
  //
  // /// ===================== LOGOUT =====================
  // Future<Response> logout() async {
  //
  //
  //   return await apiClient.postData(ApiConstants.logout, {
  //   });
  // }

  /// ===================== REFRESH TOKEN =====================
  Future<Response> refreshToken(String refreshToken) async {
    return await apiClient.postData(ApiConstants.refreshToken, {
      "refreshToken": refreshToken,
    });
  }

  // /// ===================== CHANGE PASSWORD =====================
  // Future<Response> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   return await apiClient.postData(ApiConstants.resetPassword, {
  //     "currentPassword": currentPassword,
  //     "newPassword": newPassword,
  //     "confirmPassword": confirmPassword,
  //   });
  // }


}