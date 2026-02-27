import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:moeb_26/Config/app_constants.dart';
import 'package:moeb_26/Services/storege_service.dart';

import '../Config/storage_constants.dart';
import '../Ripositoryes/auth_reporitory.dart';
import 'api_client.dart';

class AuthService extends GetxService {
  late AuthRepo _authRepo;

  // Reactive state
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Explicitly find ApiClient to ensure it's initialized before AuthRepo
    _authRepo = AuthRepo(apiClient: Get.put(ApiClient()));

    // Check initial login state
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await StorageService.getString(StorageConstants.bearerToken);
    isLoggedIn.value = token.isNotEmpty;
  }

  Future<AuthService> init() async {
    return this;
  }

  /// ===================== SIGNUP =====================
  Future<Response> signup({
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
    try {
      final response = await _authRepo.signup(
        name: name,
        email: email,
        password: password,
        phone: phone,
        home: home,
        serviceArea: serviceArea,
        experience: experience,
        company: company,
        companyRole: companyRole,
      );

      // Optional: Auto login after signup or wait for verification
      // handleAuthResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== LOGIN =====================
  Future<Response> login({
    required String email,
    required String password,

  }) async {
    try {
      // final deviceTocken = await _authRepo.getDeviceId();
      final deviceTocken =AppConstants.deviceToken;
      final response = await _authRepo.login(email: email, password: password,deviceToken:deviceTocken);
      await _handleAuthResponse(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // /// ===================== LOGOUT =====================
  // Future<Response> logout() async {
  //   try {
  //     final response = await _authRepo.logout();
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   } finally {
  //     await _clearLocalAuth();
  //   }
  // }

  /// ===================== FORGOT PASSWORD =====================
  Future<Response> forgotPassword(String email) async {
    try {
      final response = await _authRepo.forgotPassword(email: email);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== OTP VERIFY =====================
  Future<Response> verifyOtp({
    required String email,
    required int otp, // 👈 controller থেকে আসছে
  }) async {
    try {
      final response = await _authRepo.otpVerify(
        email: email,
        oneTimeCode: otp, // 👈 repo এ oneTimeCode
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== RESEND OTP =====================
  Future<void> resendOtp(String email) async {
    try {
      await _authRepo.resentOtp(email: email);
    } catch (e) {
      rethrow;
    }
  }

  /// ===================== RESET PASSWORD =====================
  Future<Response> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _authRepo.resetPassword(
        resetToken: resetToken, // 👈 যোগ করো
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  //
  // /// ===================== CHANGE PASSWORD =====================
  // Future<void> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  //   required String confirmPassword,
  // }) async {
  //   try {
  //     await _authRepo.changePassword(
  //       currentPassword: currentPassword,
  //       newPassword: newPassword,
  //       confirmPassword: confirmPassword,
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  /// ===================== HELPER METHODS =====================

  /// Handles successful auth response (Login/Signup)
  Future<void> _handleAuthResponse(Response response) async {
    // Adjust these keys based on your actual API response structure
    // Example: { "data": { "accessToken": "...", "refreshToken": "..." } }
    final data = response.data;

    // Check if data is nested
    final authData = data['data'] ?? data;

    final String? accessToken = authData['accessToken'] ?? authData['token'];
    final String? refreshToken = authData['refreshToken'];

    if (accessToken != null) {
      await StorageService.setString(StorageConstants.bearerToken, accessToken);
      isLoggedIn.value = true;
    }

    if (refreshToken != null) {
      await StorageService.setString(
        StorageConstants.refreshToken,
        refreshToken,
      );
    }
  }

  /// Clears all local auth data
  Future<void> _clearLocalAuth() async {
    await StorageService.remove(StorageConstants.bearerToken);
    await StorageService.remove(StorageConstants.refreshToken);
    await StorageService.remove(StorageConstants.userData);
    isLoggedIn.value = false;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => isLoggedIn.value;
}
