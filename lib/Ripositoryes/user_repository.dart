import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  // ========== Vehicle only ==========
  Future<Response> updateVehicles({
    required List<Map<String, dynamic>> vehicles,
  }) async {
    final formData = FormData();

    for (int i = 0; i < vehicles.length; i++) {
      vehicles[i].forEach((key, value) {
        formData.fields.add(
          MapEntry('vehicles[$i][$key]', value.toString()),
        );
      });
    }

    return await apiClient.patchData(
      ApiConstants.updateProfile,
      formData,
    );
  }

  // ========== Documents + Vehicles ==========
  Future<Response> updateDocuments({
    required List<Map<String, dynamic>> vehicles, // 👈 যোগ করা হয়েছে
    required File drivingLicense,
    required String drivingLicenseExpire,
    required File hackLicense,
    required String hackLicenseExpire,
    File? localPermit,
    String? localPermitExpire,
    required File commercialInsurance,
    required String commercialInsuranceExpire,
    required File vehicleRegistration,
    required String vehicleRegistrationExpire,
    required File headshot,
    required File frontView,
    required File rearView,
    required File interiorView,
  }) async {
    final formData = FormData();

    // 👈 vehicles JSON encode করে পাঠাও
    formData.fields.add(
      MapEntry('vehicles', jsonEncode(vehicles)),
    );

    // Expire dates
    formData.fields.addAll([
      MapEntry('drivingLicense[expireDate]', drivingLicenseExpire),
      MapEntry('hackLicense[expireDate]', hackLicenseExpire),
      MapEntry('commercialInsurance[expireDate]', commercialInsuranceExpire),
      MapEntry('vehicleRegistration[expireDate]', vehicleRegistrationExpire),
    ]);

    if (localPermitExpire != null) {
      formData.fields.add(
        MapEntry('localPermit[expireDate]', localPermitExpire),
      );
    }

    // Files
    formData.files.addAll([
      MapEntry(
        'drivingLicense[image]',
        await MultipartFile.fromFile(drivingLicense.path),
      ),
      MapEntry(
        'hackLicense[image]',
        await MultipartFile.fromFile(hackLicense.path),
      ),
      MapEntry(
        'commercialInsurance[image]',
        await MultipartFile.fromFile(commercialInsurance.path),
      ),
      MapEntry(
        'vehicleRegistration[image]',
        await MultipartFile.fromFile(vehicleRegistration.path),
      ),
      MapEntry(
        'headshot',
        await MultipartFile.fromFile(headshot.path),
      ),
      MapEntry(
        'vehiclePhotos[frontView]',
        await MultipartFile.fromFile(frontView.path),
      ),
      MapEntry(
        'vehiclePhotos[rearView]',
        await MultipartFile.fromFile(rearView.path),
      ),
      MapEntry(
        'vehiclePhotos[interiorView]',
        await MultipartFile.fromFile(interiorView.path),
      ),
    ]);

    if (localPermit != null) {
      formData.files.add(
        MapEntry(
          'localPermit[image]',
          await MultipartFile.fromFile(localPermit.path),
        ),
      );
    }

    return await apiClient.patchData(
      ApiConstants.updateProfile,
      formData,
    );
  }
}
