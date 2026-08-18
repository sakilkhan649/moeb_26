import 'package:get/get.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moeb_26/modules/my_schedule/models/my_schedule_job_model.dart';

class MyScheduleController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<MyScheduleJobModel> jobsList = <MyScheduleJobModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleJobs();
  }

  void _loadSampleJobs() {
    final now = DateTime.now();
    jobsList.assignAll([
      MyScheduleJobModel(
        id: '1',
        clientName: 'Alexander Wright',
        clientPhone: '+1 (555) 234-5678',
        pickupDateTime: DateTime(now.year, now.month, now.day, 10, 30),
        pickupLocation: 'JFK International Airport Terminal 4',
        dropoffLocation: 'The Plaza Hotel, 5th Ave, NYC',
        vehicleType: 'Executive Sedan',
        fare: '\$145.00',
        notes: 'Flight BA178. VIP client, prefers quiet ride.',
      ),
      MyScheduleJobModel(
        id: '2',
        clientName: 'Sophia Martinez',
        clientPhone: '+1 (555) 876-5432',
        pickupDateTime: DateTime(now.year, now.month, now.day, 14, 15),
        pickupLocation: 'Wall Street Financial District',
        dropoffLocation: 'LaGuardia Airport Terminal B',
        vehicleType: 'Luxury SUV',
        fare: '\$180.00',
        notes: '2 Large Luggage bags.',
      ),
      MyScheduleJobModel(
        id: '3',
        clientName: 'Robert Vance',
        clientPhone: '+1 (555) 345-6789',
        pickupDateTime: DateTime(now.year, now.month, now.day + 1, 9, 0),
        pickupLocation: 'Midtown Manhattan Corporate Center',
        dropoffLocation: 'Newark Liberty International Airport',
        vehicleType: 'Chauffeur Van',
        fare: '\$220.00',
        notes: 'Group of 4 passengers.',
      ),
    ]);
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  List<MyScheduleJobModel> get selectedDateJobs {
    final sel = selectedDate.value;
    return jobsList.where((job) {
      return job.pickupDateTime.year == sel.year &&
          job.pickupDateTime.month == sel.month &&
          job.pickupDateTime.day == sel.day;
    }).toList();
  }

  bool hasJobsOnDate(DateTime date) {
    return jobsList.any((job) =>
        job.pickupDateTime.year == date.year &&
        job.pickupDateTime.month == date.month &&
        job.pickupDateTime.day == date.day);
  }

  void addJob(MyScheduleJobModel job) {
    jobsList.add(job);
    Helpers.showCustomSnackBar(
      'Direct booking added to your schedule',
      isError: false,
    );
  }

  void updateJob(MyScheduleJobModel updatedJob) {
    final index = jobsList.indexWhere((j) => j.id == updatedJob.id);
    if (index != -1) {
      jobsList[index] = updatedJob;
      jobsList.refresh();
      Helpers.showCustomSnackBar(
        'Booking details updated successfully',
        isError: false,
      );
    }
  }

  void deleteJob(String id) {
    jobsList.removeWhere((j) => j.id == id);
    Helpers.showCustomSnackBar(
      'Booking removed from your schedule',
      isError: false,
    );
  }

  void dispatchToNetwork(MyScheduleJobModel job) {
    final index = jobsList.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      final updated = jobsList[index].copyWith(
        isDispatchedToNetwork: true,
        status: "Dispatched to Network",
      );
      jobsList[index] = updated;
      jobsList.refresh();
      Helpers.showCustomSnackBar(
        'Job successfully dispatched to the public network!',
        isError: false,
      );
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanPhone);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        Helpers.showCustomSnackBar('Calling $phoneNumber...', isError: false);
      }
    } catch (_) {
      Helpers.showCustomSnackBar('Calling $phoneNumber...', isError: false);
    }
  }
}
