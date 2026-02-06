/*
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:gifting_app/routes/routes.dart';
import '../../core/utils/app_dialog.dart';
import '../../core/utils/custom_snackbar.dart';
import '../../presentation/screens/auth_screen/verify_email.dart';
import '../../presentation/widgets/email_verify_popup.dart';

class ApiChecker {
  /// Check Dio response and show snackbar if error occurs
  static void checkApi(Response response, {bool getXSnackBar = true}) {
    // Success codes → 200 (OK), 201 (Created)
    if (response.statusCode != 200 && response.statusCode != 201) {
      if (response.statusCode == 401) {
        Get.offAllNamed(RoutePages.loginScreen);
        showCustomSnackBar(
          "Unauthorized! Please login again.",
          getXSnackBar: getXSnackBar,
        );
      } else {
        showCustomSnackBar(
          response.data["message"] ?? "Unknown error occurred",
          getXSnackBar: getXSnackBar,
        );
      }
    }
  }

  /// Handle DioError (network, timeout, server error)
  static void handleError(DioException error, {bool getXSnackBar = false}) {
    String message = "Something went wrong";

    if (error.type == DioExceptionType.connectionTimeout) {
      message = "Connection timed out";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = "Server took too long to respond";
    } else if (error.type == DioExceptionType.badResponse) {
      message = "Bad response: ${error.response?.statusMessage ?? 'Unknown'}";
    } else if (error.type == DioExceptionType.cancel) {
      message = "Request cancelled";
    } else if (error.type == DioExceptionType.unknown) {
      message = "Unexpected error: ${error.message}";
    }

    showCustomSnackBar(message, getXSnackBar: getXSnackBar);
  }
}
*/