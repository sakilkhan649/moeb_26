import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:moeb_26/data/repositories/job_repository.dart';

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
    try {
      return await _jobRepo.createJob(
        jobType: jobType,
        pickup: pickup,
        dropoff: dropoff,
        vehicleType: vehicleType,
        paymentAmount: paymentAmount,
        paymentType: paymentType,
        dispatchType: dispatchType,
        asap: asap,
        date: date,
        time: time,
        flightNumber: flightNumber,
        instruction: instruction,
        targetedChauffeurs: targetedChauffeurs,
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

  Future<Response> getJobById({required String jobId}) async {
    try {
      return await _jobRepo.getJobById(jobId: jobId);
    } catch (e) {
      rethrow;
    }
  }
}
