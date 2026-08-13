import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/data/models/vehicle_model.dart';
import 'package:moeb_26/core/services/api_client.dart';

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

  /// ===================== SIGNUP (CLEAN & SIMPLE) =====================
  Future<Response<dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String serviceArea,
    required int experience,
    required String company,
    required String companyRole,
    String? languages,
  }) async {
    return await apiClient.postData(ApiConstants.signup, {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "serviceArea": serviceArea,
      "experience": experience,
      "company": company,
      "companyRole": companyRole,
      "languages": languages ?? 'English',
    });
  }

  /// ===================== VEHICLE SETUP (SEPARATE API) =====================
  Future<Response<dynamic>> addVehicle({
    required List<VehicleModel> vehicles,
  }) async {
    final formData = FormData();
    final vehicleJsonList = vehicles.map((v) => v.toJson()).toList();
    formData.fields.add(MapEntry('vehicles', jsonEncode(vehicleJsonList)));

    for (int i = 0; i < vehicles.length; i++) {
      final v = vehicles[i];
      if (v.vehicleRegistrationFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehicleRegistrationImage',
            await MultipartFile.fromFile(v.vehicleRegistrationFile.value!.path),
          ),
        );
      }
      if (v.commercialInsuranceFile.value != null) {
        formData.files.add(
          MapEntry(
            'commercialInsuranceImage',
            await MultipartFile.fromFile(v.commercialInsuranceFile.value!.path),
          ),
        );
      }
      if (v.frontViewFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehiclePhotoFront',
            await MultipartFile.fromFile(v.frontViewFile.value!.path),
          ),
        );
      }
      if (v.rearViewFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehiclePhotoRear',
            await MultipartFile.fromFile(v.rearViewFile.value!.path),
          ),
        );
      }
      if (v.interiorViewFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehiclePhotoInterior',
            await MultipartFile.fromFile(v.interiorViewFile.value!.path),
          ),
        );
      }
    }
    return await apiClient.postData('${ApiConstants.signup}/vehicles', formData);
  }

  /// ===================== DOCUMENTS UPLOAD (SEPARATE API) =====================
  Future<Response<dynamic>> uploadDocuments({
    required File drivingLicenseFile,
    required String drivingLicenseExpiry,
    required File hackLicenseFile,
    required String hackLicenseExpiry,
    File? localPermitFile,
    String? localPermitExpiry,
    required File headshotFile,
  }) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('drivingLicenseExpiryDate', drivingLicenseExpiry),
      MapEntry('hackLicenseExpiryDate', hackLicenseExpiry),
    ]);
    if (localPermitExpiry != null) {
      formData.fields.add(MapEntry('localPermitExpiryDate', localPermitExpiry));
    }

    formData.files.addAll([
      MapEntry(
        'drivingLicenseImage',
        await MultipartFile.fromFile(drivingLicenseFile.path),
      ),
      MapEntry(
        'hackLicenseImage',
        await MultipartFile.fromFile(hackLicenseFile.path),
      ),
      MapEntry(
        'uploadedHeadshot',
        await MultipartFile.fromFile(headshotFile.path),
      ),
    ]);

    if (localPermitFile != null) {
      formData.files.add(
        MapEntry(
          'localPermitImage',
          await MultipartFile.fromFile(localPermitFile.path),
        ),
      );
    }

    return await apiClient.postData('${ApiConstants.signup}/documents', formData);
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

  /// ===================== RESET PASSWORD =====================
  Future<Response> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await apiClient.postData(ApiConstants.resetPassword, {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    }, resetToken: resetToken);
  }

  /// ===================== LOGOUT =====================
  Future<Response> logout({String? deviceToken}) async {
    return await apiClient.postData(ApiConstants.logout, {
      "deviceToken": deviceToken ?? '',
    });
  }

  /// ===================== REFRESH TOKEN =====================
  Future<Response> refreshToken(String refreshToken) async {
    return await apiClient.postData(ApiConstants.refreshToken, {
      "refreshToken": refreshToken,
    });
  }

  /// ===================== CHANGE PASSWORD =====================
  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await apiClient.postData(ApiConstants.changePassword, {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    });
  }
}
