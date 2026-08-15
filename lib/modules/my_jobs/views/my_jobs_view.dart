import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/data/models/chat_model.dart';
import 'package:moeb_26/modules/my_jobs/widgets/MyJobCard.dart';
import 'package:moeb_26/modules/my_jobs/widgets/MyJobDetailSheet.dart';
import 'package:moeb_26/modules/my_job_progress_details/views/my_job_progress_details_view.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import '../controllers/my_jobs_controller.dart';

class MyJobsView extends StatefulWidget {
  const MyJobsView({super.key});

  @override
  State<MyJobsView> createState() => _MyJobsViewState();
}

class _MyJobsViewState extends State<MyJobsView> {
  final BookingController controller = Get.find<BookingController>();

  // Static Demo Created Jobs Dataset
  final List<Map<String, dynamic>> _demoMyJobs = [
    {
      'dateHeader': 'Thu, Jul 09',
      'jobs': [
        {
          'id': 'JOB-884210',
          'time': '3:30 PM',
          'pickup': 'The Ritz-Carlton Bal Harbour',
          'pickupNotes': 'Main Lobby Valet Stand',
          'dropoff': 'PortMiami Cruise Terminal 4',
          'dropoffNotes': 'Terminal 4 VIP Dropoff Area',
          'company': 'Moeb Chauffeur Services',
          'vehicle': 'BAL-MIA',
          'type': 'SUV',
          'price': '195.00',
          'payment': 'Credit Card on File',
          'status': 'PENDING',
          'flight': 'CR-8821',
          'instructions':
              'Provide child booster seat in back row. Assistance with 4 large suitcases.',
          'assignedDriver': '1 Applicant Available',
        },
        {
          'id': 'JOB-884211',
          'time': '8:00 PM',
          'pickup': 'St. Regis Bal Harbour Resort',
          'pickupNotes': 'Ocean Drive Gate Entry',
          'dropoff': 'Hard Rock Stadium VIP Entrance',
          'dropoffNotes': 'Gate 2 VIP Parking Lot',
          'company': 'Moeb Chauffeur Services',
          'vehicle': 'ST-MIA',
          'type': 'SPRINTER',
          'price': '260.00',
          'payment': 'Credit Card on File',
          'status': 'ASSIGNED',
          'flight': 'VIP-EVENT',
          'instructions': 'Event pass required at front gate.',
          'assignedDriver': 'Mohamed El Bakkali',
        },
      ],
    },
    {
      'dateHeader': 'Tue, Jun 30',
      'jobs': [
        {
          'id': 'JOB-884200',
          'time': '8:00 AM',
          'pickup': 'Palm Beach Yacht Club',
          'pickupNotes': 'Dockside Pick-up Area',
          'dropoff': 'PBI Private Aviation Terminal',
          'dropoffNotes': 'Atlantic Aviation FBO Ramp',
          'company': 'Moeb Chauffeur Services',
          'vehicle': 'PB-YACHT',
          'type': 'SEDAN',
          'price': '140.00',
          'payment': 'Credit Card on File',
          'status': 'COMPLETED',
          'flight': 'N920AP',
          'instructions': 'Passenger carrying golf equipment.',
          'assignedDriver': 'Mohamed El Bakkali',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () {
                controller.setJobAcceptanceView(false);
                Get.toNamed(Routes.bottomNabbarView);
              },
            ),
            title: Text(
              'My Created Jobs',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _demoMyJobs.length,
          padding: EdgeInsets.only(bottom: 20.h),
          itemBuilder: (context, groupIndex) {
            final group = _demoMyJobs[groupIndex];
            final String dateHeader = group['dateHeader'];
            final List jobs = group['jobs'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Header
                Padding(
                  padding: EdgeInsets.only(top: 15.h, bottom: 10.h, left: 4.w),
                  child: Text(
                    dateHeader,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ...jobs.map((job) {
                  return MyJobCard(
                    time: job['time'],
                    pickupLocation: job['pickup'],
                    dropoffLocation: job['dropoff'],
                    companyName: job['company'],
                    assignedDriver: job['assignedDriver'],
                    vehicleType: job['type'],
                    price: job['price'],
                    status: job['status'],
                    onTap: () => _openJobDetails(job, dateHeader),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openJobDetails(Map<String, dynamic> job, String dateHeader) {
    final String status = job['status'] ?? '';
    final String upperStatus = status.toUpperCase();
    final bool canEdit = upperStatus == 'PENDING';
    final bool canDelete =
        upperStatus == 'PENDING' || upperStatus == 'CANCELLED';

    Get.bottomSheet(
      MyJobDetailSheet(
        title: "Created Job Details",
        bookingNo: job['id'],
        dateTimeStr: "$dateHeader • ${job['time']}",
        pickupLocation: job['pickup'],
        pickupNotes: job['pickupNotes'],
        dropoffLocation: job['dropoff'],
        dropoffNotes: job['dropoffNotes'],
        passengerName: job['company'],
        driverName: job['assignedDriver'],
        vehicleInfo: job['vehicle'],
        vehicleType: job['type'],
        paymentType: job['payment'],
        amount: job['price'],
        flightNumber: job['flight'],
        specialInstructions: job['instructions'],
        status: status,
        onAcceptPressed: () {
          setState(() {
            job['status'] = 'ASSIGNED';
            job['assignedDriver'] = 'Mohamed El Bakkali';
          });
          Get.snackbar(
            "Driver Assigned",
            "Accepted applicant for Job #${job['id']}. Driver assigned!",
            backgroundColor: const Color(0xFF22C55E),
            colorText: Colors.white,
          );
        },
        onRejectPressed: () {
          setState(() {
            job['assignedDriver'] = 'Awaiting Driver';
          });
          Get.snackbar(
            "Applicant Declined",
            "Applicant declined for Job #${job['id']}. Job is open again.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        },
        onChatPressed: () {
          final driverName =
              (job['assignedDriver'] != null &&
                  job['assignedDriver'] != '1 Applicant Available')
              ? job['assignedDriver']
              : "Mohamed El Bakkali";
          final chat = ChatPreview(
            id: "demo_chat_${job['id']}",
            participants: [ChatParticipant(id: "driver_1", name: driverName)],
            lastMessage: "Hello, I am ready for this job assignment.",
            lastMessageAt: DateTime.now().toIso8601String(),
            createdBy: "current_user",
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          );
          Get.toNamed(Routes.chatDetailView, arguments: chat);
        },
        onActionButtonPressed: () {
          if (job['status'] == 'ASSIGNED') {
            Get.to(() => const MyJobProgressDetailsView());
          }
        },
        onReviewPressed: () {
          Get.toNamed(Routes.ratingsFeedbackView);
        },
        onEditPressed: canEdit
            ? () {
                Get.snackbar(
                  "Edit Job",
                  "Opening Job Editor for #${job['id']}",
                  backgroundColor: const Color(0xFFD08700),
                  colorText: Colors.white,
                );
              }
            : null,
        onDeletePressed: canDelete
            ? () {
                _showDeleteDialog(jobId: job['id']);
              }
            : null,
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  void _showDeleteDialog({required String jobId}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFF2C2C2C)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delete Job",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Are you sure you want to delete job #$jobId?",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Cancel",
                      backgroundColor: Colors.transparent,
                      textColor: Colors.white,
                      borderColor: Colors.grey,
                      fontSize: 14.sp,
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      text: "Delete",
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.black,
                      fontSize: 14.sp,
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          "Job Deleted",
                          "Job #$jobId has been deleted",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      },
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
