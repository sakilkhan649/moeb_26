import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/ExecutiveRideCard.dart';
import 'package:moeb_26/core/widgets/ExecutiveRideDetailSheet.dart';
import 'package:moeb_26/core/widgets/Custom_Job_Button.dart';
import '../../../core/widgets/Custom_AppBar.dart';
import '../../jobs_posts/views/job_post_sheet_tabbar_view.dart';

class JobOfferView extends StatefulWidget {
  const JobOfferView({super.key});

  @override
  State<JobOfferView> createState() => _JobOfferViewState();
}

class _JobOfferViewState extends State<JobOfferView> {
  // Static Demo Job Offers Dataset
  final List<Map<String, dynamic>> _demoJobOffers = [
    {
      'dateHeader': 'Thu, Jul 09',
      'offers': [
        {
          'bookingNo': 'OFFER-884201',
          'time': '1:45 PM',
          'pickup': 'Boca Raton Executive Airport (BCT)',
          'pickupNotes': 'Signature Flight Support FBO Gate 3',
          'dropoff': 'Four Seasons Resort Palm Beach',
          'dropoffNotes': 'Valet Main Entrance',
          'passenger': 'David Sterling',
          'company': 'Apex Luxury Chauffeur',
          'vehicle': 'BCT-FBO',
          'type': 'SUV',
          'price': '250.00',
          'payment': 'Credit Card on File',
          'flight': 'N482AP',
          'instructions':
              'Guest requires meet & greet sign in terminal. Please assist with luggage.',
        },
        {
          'bookingNo': 'OFFER-884202',
          'time': '6:00 PM',
          'pickup': 'Fort Lauderdale-Hollywood Int Airport (FLL)',
          'pickupNotes': 'Terminal 3 Arrivals Terminal',
          'dropoff': 'Ritz-Carlton Fort Lauderdale',
          'dropoffNotes': 'Beachfront Driveway Entrance',
          'passenger': 'Elena Rostova',
          'company': 'VIP Transit Miami',
          'vehicle': 'FLL-MIA',
          'type': 'SPRINTER',
          'price': '320.00',
          'payment': 'Credit Card on File',
          'flight': 'AA1042',
          'instructions':
              'Provide chilled bottled water and assistance with 3 bags.',
        },
      ],
    },
    {
      'dateHeader': 'Fri, Jul 10',
      'offers': [
        {
          'bookingNo': 'OFFER-884203',
          'time': '10:15 AM',
          'pickup': 'Downtown Miami Financial District',
          'pickupNotes': 'Brickell World Plaza Lobby',
          'dropoff': 'Miami International Airport (MIA)',
          'dropoffNotes': 'Terminal D American Airlines VIP',
          'passenger': 'Robert Vance',
          'company': 'Global Black Car',
          'vehicle': 'MIA-920',
          'type': 'SEDAN',
          'price': '160.00',
          'payment': 'Credit Card on File',
          'flight': 'DL492',
          'instructions':
              'Silent ride requested. Preferred AC temperature 70F.',
        },
        {
          'bookingNo': 'OFFER-884204',
          'time': '4:30 PM',
          'pickup': 'PortMiami Cruise Terminal 4',
          'pickupNotes': 'VIP Passenger Pickup Zone C',
          'dropoff': 'The Setai South Beach',
          'dropoffNotes': 'Collins Ave Entrance',
          'passenger': 'Marcus Thorne',
          'company': 'Ocean Drive Chauffeur',
          'vehicle': 'MIA-881',
          'type': 'SEDAN/SUV',
          'price': '210.00',
          'payment': 'Credit Card on File',
          'flight': 'CR-9201',
          'instructions': 'Child safety seat needed in rear passenger seat.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: "Offers", notificationCount: 3),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),
            // Top Action Buttons Header
            Row(
              children: [
                Expanded(
                  child: CustomJobButton(
                    text: "New Job",
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 8.w,
                    ),
                    onPressed: () {
                      Get.to(() => JobPostSheetTabBarView());
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomJobButton(
                    text: "My Jobs",
                    iconPath: AppIcons.edit_icon_myjob,
                    iconSize: 18.w,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 8.w,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.myJobsView);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            // Job Offers List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _demoJobOffers.length,
                padding: EdgeInsets.only(bottom: 20.h),
                itemBuilder: (context, groupIndex) {
                  final group = _demoJobOffers[groupIndex];
                  final String dateHeader = group['dateHeader'];
                  final List offers = group['offers'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Section Header
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15.h,
                          bottom: 10.h,
                          left: 4.w,
                        ),
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
                      ...offers.map((job) {
                        return ExecutiveRideCard(
                          time: job['time'],
                          pickupLocation: job['pickup'],
                          dropoffLocation: job['dropoff'],
                          passengerOrDriverName: job['passenger'],
                          vehicleInfo: job['company'],
                          vehicleType: job['type'],
                          price: job['price'],
                          paymentType: job['payment'],
                          status: 'OFFER',
                          onTap: () {
                            Get.bottomSheet(
                              ExecutiveRideDetailSheet(
                                title: "Job Offer Details",
                                bookingNo: job['bookingNo'],
                                dateTimeStr: "$dateHeader • ${job['time']}",
                                pickupLocation: job['pickup'],
                                pickupNotes: job['pickupNotes'],
                                dropoffLocation: job['dropoff'],
                                dropoffNotes: job['dropoffNotes'],
                                passengerName: job['passenger'],
                                driverName: job['company'],
                                vehicleInfo: job['vehicle'],
                                vehicleType: job['type'],
                                paymentType: job['payment'],
                                amount: job['price'],
                                flightNumber: job['flight'],
                                specialInstructions: job['instructions'],
                                status: "AVAILABLE",
                                actionButtonText: "Accept Job Offer",
                                onActionButtonPressed: () {
                                  Get.snackbar(
                                    "Job Accepted",
                                    "Successfully applied for Job Offer #${job['bookingNo']}",
                                    backgroundColor: const Color(0xFFD08700),
                                    colorText: Colors.white,
                                  );
                                },
                              ),
                              isScrollControlled: true,
                              ignoreSafeArea: false,
                            );
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
