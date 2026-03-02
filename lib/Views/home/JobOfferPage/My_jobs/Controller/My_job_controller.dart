import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Services/job_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class BookingController extends GetxController {
  final JobService _jobService = Get.find<JobService>();

  var isDeleted = false.obs;
  var isJobAcceptanceView = false.obs;

  var isLoadingList = false.obs;
  var jobsList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoadingList.value = true;
      final response = await _jobService.getJobs();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {

          jobsList.value = response.data['data'];
        }
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to fetch jobs.')
            : 'Failed to fetch jobs.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to fetch jobs.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
  }

  void deleteItem() {
    isDeleted.value = true;
  }

  void setJobAcceptanceView(bool value) {
    isJobAcceptanceView.value = value;
  }
}
