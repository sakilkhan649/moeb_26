import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/auth_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class SignupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;

  // ============ Step 1: Account Info ============
  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  String home = '';
  String serviceArea = '';
  int experience = 0;
  String company = '';
  String companyRole = '';

  // ============ Step 2: Vehicles ============
  List<Map<String, dynamic>> vehicles = [];

  // ============ Step 3: Documents ============
  File? drivingLicenseFile;
  String drivingLicenseExpiry = '';

  File? hackLicenseFile;
  String hackLicenseExpiry = '';

  File? localPermitFile;
  String? localPermitExpiry;

  File? commercialInsuranceFile;
  String commercialInsuranceExpiry = '';

  File? vehicleRegistrationFile;
  String vehicleRegistrationExpiry = '';

  File? headshotFile;

  File? vehiclePhotoFront;
  File? vehiclePhotoRear;
  File? vehiclePhotoInterior;

  // ============ Save Step 1 ============
  void saveAccountInfo({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String home,
    required String serviceArea,
    required int experience,
    required String company,
    required String companyRole,
  }) {
    this.name = name;
    this.email = email;
    this.password = password;
    this.phone = phone;
    this.home = home;
    this.serviceArea = serviceArea;
    this.experience = experience;
    this.company = company;
    this.companyRole = companyRole;
  }

  // ============ Save Step 2 ============
  void saveVehicles(List<Map<String, dynamic>> vehicles) {
    this.vehicles = vehicles;
  }

  // ============ Save Step 3 ============
  void saveDocuments({
    required File drivingLicense,
    required String drivingLicenseExpiry,
    required File hackLicense,
    required String hackLicenseExpiry,
    File? localPermit,
    String? localPermitExpiry,
    required File commercialInsurance,
    required String commercialInsuranceExpiry,
    required File vehicleRegistration,
    required String vehicleRegistrationExpiry,
    required File headshot,
    required File front,
    required File rear,
    required File interior,
  }) {
    drivingLicenseFile = drivingLicense;
    this.drivingLicenseExpiry = drivingLicenseExpiry;
    hackLicenseFile = hackLicense;
    this.hackLicenseExpiry = hackLicenseExpiry;
    localPermitFile = localPermit;
    this.localPermitExpiry = localPermitExpiry;
    commercialInsuranceFile = commercialInsurance;
    this.commercialInsuranceExpiry = commercialInsuranceExpiry;
    vehicleRegistrationFile = vehicleRegistration;
    this.vehicleRegistrationExpiry = vehicleRegistrationExpiry;
    headshotFile = headshot;
    vehiclePhotoFront = front;
    vehiclePhotoRear = rear;
    vehiclePhotoInterior = interior;
  }

  // ============ Final Submit — POST /user ============
  Future<void> submitAll() async {
    try {
      isLoading.value = true;

      final response = await _authService.signup(
        name: name,
        email: email,
        password: password,
        phone: phone,
        home: home,
        serviceArea: serviceArea,
        experience: experience,
        company: company,
        companyRole: companyRole,
        vehicles: vehicles,
        drivingLicenseFile: drivingLicenseFile!,
        drivingLicenseExpiry: drivingLicenseExpiry,
        hackLicenseFile: hackLicenseFile!,
        hackLicenseExpiry: hackLicenseExpiry,
        localPermitFile: localPermitFile,
        localPermitExpiry: localPermitExpiry,
        commercialInsuranceFile: commercialInsuranceFile!,
        commercialInsuranceExpiry: commercialInsuranceExpiry,
        vehicleRegistrationFile: vehicleRegistrationFile!,
        vehicleRegistrationExpiry: vehicleRegistrationExpiry,
        headshotFile: headshotFile!,
        vehiclePhotoFront: vehiclePhotoFront!,
        vehiclePhotoRear: vehiclePhotoRear!,
        vehiclePhotoInterior: vehiclePhotoInterior!,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Registration successful', isError: false);
        Get.toNamed(
          Routes.otpVerificationScreen,
          arguments: {'email': email, 'isRegister': true},
        );
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Registration failed.')
            : 'Registration failed.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Registration failed.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
