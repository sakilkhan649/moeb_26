import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class JobRepo {
  final ApiClient apiClient;
  JobRepo({required this.apiClient});

  Future<Response> createJob({
    required String jobType,
    required String pickupLocation,
    String? dropoffLocation,
    String? flightNumber,
    String? duration,
    required String date,
    required String time,
    required String vehicleType,
    required double paymentAmount,
    required String paymentType,
    String? instruction,
  }) async {
    final Map<String, dynamic> body = {
      "jobType": jobType,
      "pickupLocation": pickupLocation,
      "date": date,
      "time": time,
      "vehicleType": vehicleType,
      "paymentAmount": paymentAmount,
      "paymentType": paymentType,
    };

    if (dropoffLocation != null && dropoffLocation.isNotEmpty) {
      body["dropoffLocation"] = dropoffLocation;
    }
    if (flightNumber != null && flightNumber.isNotEmpty) {
      body["flightNumber"] = flightNumber;
    }
    if (duration != null && duration.isNotEmpty) {
      body["duration"] = duration;
    }
    if (instruction != null && instruction.isNotEmpty) {
      body["instruction"] = instruction;
    }

    return await apiClient.postData(ApiConstants.createJob, body);
  }

  Future<Response> getJobs() async {
    return await apiClient.getData(
      ApiConstants.createJob,
    ); // Same endpoint /jobs
  }
}
