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

  Future<Response> getJobs({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.myJobs,
      query: {'page': page, 'limit': limit},
    ); // Same endpoint /jobs
  }

  Future<Response> getAllJobOffers({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.getAllJobOffers,
      query: {'page': page, 'limit': limit},
    );
  }

  Future<Response> applyToJob({required String jobId}) async {
    return await apiClient.postData(
      ApiConstants.applytoJob.replaceAll('{jobId}', jobId),
      null,
    );
  }

  Future<Response> getPendingJobs({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.myRides,
      query: {'type': 'pending', 'page': page, 'limit': limit},
    );
  }

  Future<Response> getUpcomingJobs({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.myRides,
      query: {'type': 'upcoming', 'page': page, 'limit': limit},
    );
  }

  Future<Response> getPastJobs({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.myRides,
      query: {'type': 'past', 'page': page, 'limit': limit},
    );
  }

  Future<Response> rejectApplicant({required String jobId}) async {
    return await apiClient.patchData(
      ApiConstants.rejectApplicant.replaceAll('{jobId}', jobId),
      null,
    );
  }

  Future<Response> approveApplicant({required String jobId}) async {
    return await apiClient.patchData(
      ApiConstants.approveApplicant.replaceAll('{jobId}', jobId),
      null,
    );
  }

  Future<Response> cancelJobOffer({required String jobId}) async {
    return await apiClient.patchData(
      ApiConstants.cancelJobOffer.replaceAll('{jobId}', jobId),
      null,
    );
  }

  Future<Response> updateJob({
    required String jobId,
    required String pickupLocation,
    required double paymentAmount,
    required String instruction,
    required String dropoffLocation,
    required String date,
    required String time,
    required String vehicleType,
    required String paymentType,
    required String jobType,
  }) async {
    return await apiClient
        .patchData(ApiConstants.updateJob.replaceAll('{jobId}', jobId), {
          "pickupLocation": pickupLocation,
          "paymentAmount": paymentAmount,
          "instruction": instruction,
          "dropoffLocation": dropoffLocation,
          "date": date,
          "time": time,
          "vehicleType": vehicleType,
          "paymentType": paymentType,
          "jobType": jobType,
        });
  }

  Future<Response> deleteJob({required String jobId}) async {
    return await apiClient.deleteData(
      ApiConstants.updateJob.replaceAll('{jobId}', jobId),
    );
  }

  Future<Response> updateRideStatus({
    required String jobId,
    required String rideStatus,
  }) async {
    return await apiClient.patchData(
      ApiConstants.updateRideStatus.replaceAll('{jobId}', jobId),
      {"rideStatus": rideStatus},
    );
  }
}
