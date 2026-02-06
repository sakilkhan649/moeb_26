import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:moeb_26/Services/storege_service.dart';

import '../Config/api_constants.dart';
import '../Config/storage_constants.dart';
import '../widgets/Custom_snacbar.dart';

class ApiClient extends GetxService {
  static late Dio dio;
  static String bearerToken = "";

  static const String noInternetMessage =
      "Sorry! Something went wrong, please try again";
  static const int timeoutInSeconds = 30;



  Future<void> fakeLogout() async {
    try {
      // Clear tokens from StorageService
      await StorageService.setString(StorageConstants.bearerToken, "");
      await StorageService.setString(StorageConstants.refreshToken, "");

      // Optional: Clear other user-related data if needed
      // await PrefsHelper.clearAll();

      // Show success message

      // Navigate to login screen

    } catch (e) {
      showCustomSnackBar(" failed: $e", isError: true);
    }
  }
  void handleTokenExpired() {
    fakeLogout();

    showCustomSnackBar("Session expired. Please login again.", isError: true);

    //Get.offAllNamed(AppRoutes.LOGIN);
  }

  @override
  void onInit() {
    super.onInit();
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: timeoutInSeconds),
        receiveTimeout: const Duration(seconds: timeoutInSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          bearerToken = await StorageService.getString(StorageConstants.bearerToken);
          if (bearerToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $bearerToken';
          }
          debugPrint("====> API Request: ${options.method} ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            "====> API Response: [${response.statusCode}] ${response.data}",
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Token expired
            handleTokenExpired();
          }
          debugPrint("====> API Error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// GET
  Future<Response> getData(
      String uri, {
        Map<String, dynamic>? query,
        CancelToken? cancelToken,
      }) async {
    try {
      return await dio.get(
        uri,
        queryParameters: query,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// POST
  Future<Response> postData(
      String uri,
      dynamic body, {
        CancelToken? cancelToken,
      }) async {
    try {
      return await dio.post(uri, data: body, cancelToken: cancelToken);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// PUT
  Future<Response> putData(
      String uri,
      dynamic body, {
        CancelToken? cancelToken,
      }) async {
    try {
      return await dio.put(uri, data: body, cancelToken: cancelToken);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// PATCH (missing before)
  Future<Response> patchData(
      String uri,
      dynamic body, {
        CancelToken? cancelToken,
      }) async {
    try {
      return await dio.patch(uri, data: body, cancelToken: cancelToken);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// DELETE
  Future<Response> deleteData(
      String uri, {
        dynamic body,
        CancelToken? cancelToken,
      }) async {
    try {
      return await dio.delete(uri, data: body, cancelToken: cancelToken);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// Multipart POST with progress
  Future<Response> postMultipartData(
      String uri,
      Map<String, dynamic> body, {
        required List<MultipartBody> multipartBody,
        Function(int, int)? onSendProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      FormData formData = FormData.fromMap(body);
      for (MultipartBody element in multipartBody) {
        formData.files.add(
          MapEntry(
            element.key,
            await MultipartFile.fromFile(element.file.path),
          ),
        );
      }
      return await dio.post(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// Multipart PUT with progress
  Future<Response> putMultipartData(
      String uri,
      Map<String, dynamic> body, {
        required List<MultipartBody> multipartBody,
        Function(int, int)? onSendProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      FormData formData = FormData.fromMap(body);
      for (MultipartBody element in multipartBody) {
        formData.files.add(
          MapEntry(
            element.key,
            await MultipartFile.fromFile(element.file.path),
          ),
        );
      }
      return await dio.put(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// File Download
  Future<Response> downloadFile(
      String url,
      String savePath, {
        Function(int, int)? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      return await dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// Error handler
  Response _handleError(DioException e) {
    String message = noInternetMessage;
    if (e.type == DioExceptionType.connectionTimeout) {
      message = "Connection timed out";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = "Server took too long to respond";
    } else if (e.type == DioExceptionType.badResponse) {
      message = "Bad response: ${e.response?.statusMessage ?? 'Unknown'}";
    } else if (e.type == DioExceptionType.cancel) {
      message = "Request cancelled";
    } else if (e.type == DioExceptionType.unknown) {
      message = "Unexpected error: ${e.message}";
    }

    return Response(
      requestOptions: e.requestOptions,
      statusCode: e.response?.statusCode ?? 0,
      statusMessage: message,
      data: e.response?.data,
    );
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}