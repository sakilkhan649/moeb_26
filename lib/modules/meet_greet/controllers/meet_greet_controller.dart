import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moeb_26/core/services/job_service.dart';
import 'package:moeb_26/data/models/my_jobs_model.dart';
import 'package:moeb_26/core/utils/helpers.dart';

class MeetGreetThemeData {
  final String name;
  final Color backgroundColor;
  final Color cardColor;
  final Color borderColor;
  final Color headerColor;
  final Color nameColor;
  final Color subtitleColor;
  final Color accentColor;

  const MeetGreetThemeData({
    required this.name,
    required this.backgroundColor,
    required this.cardColor,
    required this.borderColor,
    required this.headerColor,
    required this.nameColor,
    required this.subtitleColor,
    required this.accentColor,
  });
}

class MeetGreetController extends GetxController {
  // Main reactive fields
  var passengerName = 'JOHN SMITH'.obs;
  var subtitleText = 'FLIGHT BG-088'.obs;
  var headerTag = 'PICKUP'.obs;
  var selectedThemeIndex = 0.obs;
  var showCompanyLogo = true.obs;
  var showQrCode = false.obs;
  var qrData = 'https://example.com/ride'.obs;
  var isLandscape = false.obs;
  var isFlashingText = false.obs;
  var isFullscreen = false.obs;
  var fontSizeScale = 1.0.obs;

  // Active jobs for dynamic fetch
  var isLoadingJobs = false.obs;
  RxList<JobData> activeJobsList = <JobData>[].obs;
  Rx<JobData?> selectedJob = Rx<JobData?>(null);

  // Preset Header Tags
  final List<String> headerTagPresets = [
    'PICKUP',
    'WELCOME',
    'VIP GUEST',
    'AIRPORT PICKUP',
    'HOTEL TRANSFER',
    'COURIER',
  ];

  // Curated Luxurious Themes (Matches Create Invoice Flow)
  final List<MeetGreetThemeData> themes = [
    const MeetGreetThemeData(
      name: 'Black & Gold',
      backgroundColor: Color(0xFF000000),
      cardColor: Color(0xFF161618),
      borderColor: Color(0xFF364153),
      headerColor: Color(0xFFD5C4AB),
      nameColor: Colors.white,
      subtitleColor: Color(0xFFC5A880),
      accentColor: Color(0xFFD5C4AB),
    ),
    const MeetGreetThemeData(
      name: 'Monochrome',
      backgroundColor: Color(0xFF000000),
      cardColor: Color(0xFF121212),
      borderColor: Color(0xFF444444),
      headerColor: Colors.white,
      nameColor: Colors.white,
      subtitleColor: Color(0xFFAAAAAA),
      accentColor: Colors.white,
    ),
    const MeetGreetThemeData(
      name: 'Amber Night',
      backgroundColor: Color(0xFF0D0B00),
      cardColor: Color(0xFF1F1B00),
      borderColor: Color(0xFFFFB703),
      headerColor: Color(0xFFFFB703),
      nameColor: Color(0xFFFFF3C4),
      subtitleColor: Color(0xFFFFD166),
      accentColor: Color(0xFFFFB703),
    ),
    const MeetGreetThemeData(
      name: 'Executive Navy',
      backgroundColor: Color(0xFF070E1A),
      cardColor: Color(0xFF0F1B2E),
      borderColor: Color(0xFF3A506B),
      headerColor: Color(0xFFE5C158),
      nameColor: Colors.white,
      subtitleColor: Color(0xFF90E0EF),
      accentColor: Color(0xFFE5C158),
    ),
    const MeetGreetThemeData(
      name: 'Crimson VIP',
      backgroundColor: Color(0xFF140306),
      cardColor: Color(0xFF260A10),
      borderColor: Color(0xFF800F2F),
      headerColor: Color(0xFFFF4D6D),
      nameColor: Colors.white,
      subtitleColor: Color(0xFFFF758F),
      accentColor: Color(0xFFFF4D6D),
    ),
  ];

  MeetGreetThemeData get currentTheme => themes[selectedThemeIndex.value];

  @override
  void onInit() {
    super.onInit();
    fetchActiveJobs();
    resetOrientation();
  }

  @override
  void onClose() {
    exitFullscreen();
    resetOrientation();
    super.onClose();
  }

  // Fetch active rides to populate dropdown/chips if available
  Future<void> fetchActiveJobs() async {
    try {
      isLoadingJobs.value = true;
      if (Get.isRegistered<JobService>()) {
        final jobService = Get.find<JobService>();
        final response = await jobService.getJobs(page: 1, limit: 10);
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data != null && response.data['data'] != null) {
            final jobResponse = MyJobsModel.fromJson(response.data);
            activeJobsList.assignAll(jobResponse.data ?? []);
          }
        }
      }
    } catch (_) {
      // Ignore fallback if offline or no active jobs
    } finally {
      isLoadingJobs.value = false;
    }
  }

  void selectJob(JobData job) {
    selectedJob.value = job;

    // Auto populate fields from job
    String name = '';
    if (job.createdBy is Driver) {
      name = (job.createdBy as Driver).name ?? '';
    } else if (job.assignedTo != null && job.assignedTo!.name != null) {
      name = job.assignedTo!.name!;
    }

    if (name.isNotEmpty) {
      passengerName.value = name.toUpperCase();
    }

    if (job.flightNumber != null && job.flightNumber!.isNotEmpty) {
      subtitleText.value = 'FLIGHT ${job.flightNumber!.toUpperCase()}';
    } else if (job.jobType != null) {
      subtitleText.value = job.jobType!.toUpperCase();
    }

    qrData.value = 'Ride ID: ${job.id ?? "N/A"} | ${passengerName.value}';
    Helpers.showCustomSnackBar(
      'Loaded details for passenger ${passengerName.value}',
      isError: false,
    );
  }

  void enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    isFullscreen.value = true;
  }

  void exitFullscreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    isFullscreen.value = false;
  }

  void toggleOrientation() {
    isLandscape.value = !isLandscape.value;
    if (isLandscape.value) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void resetOrientation() {
    isLandscape.value = false;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
