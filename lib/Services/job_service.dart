import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../Ripositoryes/job_repository.dart';

class JobService extends GetxService {
  late JobRepo _jobRepo;

  @override
  void onInit() {
    super.onInit();
    _jobRepo = JobRepo(apiClient: Get.find());
  }

  Future<JobService> init() async {
    return this;
  }

  Future<Response> createJob({
    required String jobType,
    required String pickupLocation,
    String? dropoffLocation,
    String? flightNumber,
    String? duration,
    String? date,
    String? time,
    bool? asap,
    required String vehicleType,
    required double paymentAmount,
    required String paymentType,
    String? instruction,
  }) async {
    try {
      return await _jobRepo.createJob(
        jobType: jobType,
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
        flightNumber: flightNumber,
        duration: duration,
        date: date,
        time: time,
        asap: asap,
        vehicleType: vehicleType,
        paymentAmount: paymentAmount,
        paymentType: paymentType,
        instruction: instruction,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getJobs({int page = 1, int limit = 10}) async {
    try {
      return await _jobRepo.getJobs(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllJobOffers({int page = 1, int limit = 10}) async {
    try {
      return await _jobRepo.getAllJobOffers(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> applyToJob({required String jobId}) async {
    try {
      return await _jobRepo.applyToJob(jobId: jobId);
    } catch (e) {
      rethrow;
    }
  }
}
