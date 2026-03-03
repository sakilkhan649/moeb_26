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
      ApiConstants.myJobs,
    ); // Same endpoint /jobs
  }

  Future<Response> getAllJobOffers() async {
    return await apiClient.getData(
      ApiConstants.getAllJobOffers,
    );
  }

  Future<Response> applyToJob({
    required String jobId,
  }) async {
    return await apiClient.postData(
      ApiConstants.applytoJob.replaceAll('{jobId}', jobId),
      null,
    );
  }

  Future<Response> getPendingJobs({
    int page = 1,
    int limit = 10,
  }) async {
    return await apiClient.getData(
      ApiConstants.myRides,
      query: {'type': 'pending', 'page': page, 'limit': limit},
    );
  }

  Future<Response> getUpcomingJobs({
    int page = 1,
    int limit = 10,
  }) async {
    return await apiClient.getData(
      ApiConstants.myRides,
      query: {'type': 'upcoming', 'page': page, 'limit': limit},
    );
  }

  Future<Response> getPastJobs({
    int page = 1,
    int limit = 10,
  }) async {
    return await apiClient.getData(
      ApiConstants.myRides,
      query: {'type': 'past', 'page': page, 'limit': limit},
    );
  }
}
