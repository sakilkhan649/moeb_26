import 'package:dio/dio.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';

class JobRepo {
  final ApiClient apiClient;
  JobRepo({required this.apiClient});

  Future<Response> createJob({
    required String jobType,
    required String pickup,
    required String dropoff,
    required String vehicleType,
    required double paymentAmount,
    required String paymentType,
    required String dispatchType,
    bool asap = false,
    String? date,
    String? time,
    String? flightNumber,
    String? instruction,
    List<String>? targetedChauffeurs,
  }) async {
    final Map<String, dynamic> body = {
      "jobType": jobType,
      "pickup": pickup,
      "dropoff": dropoff,
      "vehicleType": vehicleType,
      "paymentAmount": paymentAmount,
      "paymentType": paymentType,
      "dispatchType": dispatchType,
      "asap": asap,
    };

    if (!asap) {
      if (date != null && date.isNotEmpty) {
        body["date"] = date;
      }
      if (time != null && time.isNotEmpty) {
        body["time"] = time;
      }
    }

    if (flightNumber != null && flightNumber.isNotEmpty) {
      body["flightNumber"] = flightNumber;
    }
    if (instruction != null && instruction.isNotEmpty) {
      body["instruction"] = instruction;
    }
    if (dispatchType == "TARGETED CHAUFFEURS" && targetedChauffeurs != null) {
      body["targetedChauffeurs"] = targetedChauffeurs;
    } else {
      body["targetedChauffeurs"] = [];
    }

    return await apiClient.postData(ApiConstants.createJob, body);
  }

  Future<Response> getJobs({String? cursor, int limit = 10}) async {
    final Map<String, dynamic> query = {'limit': limit};
    if (cursor != null && cursor.isNotEmpty) {
      query['cursor'] = cursor;
    }
    return await apiClient.getData(
      ApiConstants.myJobs,
      query: query,
    );
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
    String? date,
    String? time,
    required String vehicleType,
    required String paymentType,
    required String jobType,
    String? flightNumber,
    bool asap = false,
  }) async {
    final Map<String, dynamic> body = {
      "pickup": pickupLocation,
      "pickupLocation": pickupLocation,
      "dropoff": dropoffLocation,
      "dropoffLocation": dropoffLocation,
      "paymentAmount": paymentAmount,
      "instruction": instruction,
      "vehicleType": vehicleType,
      "paymentType": paymentType,
      "jobType": jobType,
      "asap": asap,
    };

    if (!asap) {
      if (date != null && date.isNotEmpty) {
        body["date"] = date;
      }
      if (time != null && time.isNotEmpty) {
        body["time"] = time;
      }
    }

    if (flightNumber != null && flightNumber.isNotEmpty) {
      body["flightNumber"] = flightNumber;
    }

    return await apiClient.patchData(
      ApiConstants.updateJob.replaceAll('{jobId}', jobId),
      body,
    );
  }

  Future<Response> deleteJob({required String jobId}) async {
    return await apiClient.deleteData(
      ApiConstants.updateJob.replaceAll('{jobId}', jobId),
    );
  }

  Future<Response> getJobById({required String jobId}) async {
    return await apiClient.getData(
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

  Future<Response> submitReview({
    required String jobId,
    required int rating,
    String? comment,
  }) async {
    return await apiClient.postData(
      ApiConstants.jobReview.replaceAll('{jobId}', jobId),
      {
        "rating": rating,
        if (comment != null && comment.isNotEmpty) "comment": comment,
      },
    );
  }
}
