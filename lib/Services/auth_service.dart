//
// import 'package:get/get.dart';
// import 'package:moeb_26/Services/storege_service.dart';
//
// import '../Config/storage_constants.dart';
// import '../Ripositoryes/auth_reporitory.dart';
// import 'api_client.dart';
//
//
// class AuthService extends GetxService {
//   late AuthRepo _authRepo;
//
//   // Reactive state
//   final isLoggedIn = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Explicitly find ApiClient to ensure it's initialized before AuthRepo
//     _authRepo = AuthRepo(apiClient: Get.put(ApiClient()));
//
//
//     // Check initial login state
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final token = await StorageService.getString(StorageConstants.bearerToken);
//     isLoggedIn.value = token.isNotEmpty;
//   }
//
//   Future<AuthService> init() async {
//     return this;
//   }
//
//   /// ===================== SIGNUP =====================
//   Future<void> signup({
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//     required String country,
//   }) async {
//     try {
//       await _authRepo.signup(
//         name: name,
//         email: email,
//         password: password,
//         phone: phone,
//         country: country,
//       );
//
//       // Optional: Auto login after signup or wait for verification
//       // handleAuthResponse(response);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== LOGIN =====================
//   Future<void> login({required String email, required String password}) async {
//     try {
//       final response = await _authRepo.login(email: email, password: password);
//       await _handleAuthResponse(response);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== LOGOUT =====================
//   Future<void> logout() async {
//     try {
//       await _authRepo.logout();
//     } catch (e) {
//       // Continue to clear local storage even if API call fails
//     } finally {
//       await _clearLocalAuth();
//     }
//   }
//
//   /// ===================== FORGOT PASSWORD =====================
//   Future<void> forgotPassword(String email) async {
//     try {
//       await _authRepo.forgotPassword(email: email);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== OTP VERIFY =====================
//   Future<void> verifyOtp({required String email, required int otp}) async {
//     try {
//       await _authRepo.otpVerify(email: email, oneTimeCode: otp);
//       // If OTP verification logs the user in directly:
//       // await _handleAuthResponse(response);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== RESEND OTP =====================
//   Future<void> resendOtp(String email) async {
//     try {
//       await _authRepo.resentOtp(email: email);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== RESET PASSWORD =====================
//   Future<void> resetPassword({
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       await _authRepo.resetPassword(
//         newPassword: newPassword,
//         confirmPassword: confirmPassword,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== CHANGE PASSWORD =====================
//   Future<void> changePassword({
//     required String currentPassword,
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       await _authRepo.changePassword(
//         currentPassword: currentPassword,
//         newPassword: newPassword,
//         confirmPassword: confirmPassword,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// ===================== HELPER METHODS =====================
//
//   /// Handles successful auth response (Login/Signup)
//   Future<void> _handleAuthResponse(Response response) async {
//     // Adjust these keys based on your actual API response structure
//     // Example: { "data": { "accessToken": "...", "refreshToken": "..." } }
//     final data = response.data;
//
//     // Check if data is nested
//     final authData = data['data'] ?? data;
//
//     final String? accessToken = authData['accessToken'] ?? authData['token'];
//     final String? refreshToken = authData['refreshToken'];
//
//     if (accessToken != null) {
//       await StorageService.setString(StorageConstants.bearerToken, accessToken);
//       isLoggedIn.value = true;
//     }
//
//     if (refreshToken != null) {
//       await StorageService.setString(
//         StorageConstants.refreshToken,
//         refreshToken,
//       );
//     }
//   }
//
//   /// Clears all local auth data
//   Future<void> _clearLocalAuth() async {
//     await StorageService.remove(StorageConstants.bearerToken);
//     await StorageService.remove(StorageConstants.refreshToken);
//     await StorageService.remove(StorageConstants.userData);
//     isLoggedIn.value = false;
//   }
//
//   /// Check if user is authenticated
//   bool get isAuthenticated => isLoggedIn.value;
// }