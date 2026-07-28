import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/core/widgets/ExecutiveRideCard.dart';
import 'package:moeb_26/core/widgets/ExecutiveRideDetailSheet.dart';
import '../../../core/widgets/Custom_AppBar.dart';
import '../controllers/rides_controller.dart';

class RidesView extends StatefulWidget {
  const RidesView({super.key});

  @override
  State<RidesView> createState() => _RidesViewState();
}

class _RidesViewState extends State<RidesView> {
  final RidesController controller = Get.find<RidesController>();
  final List<String> _tabs = ["Upcoming", "Past"];
  int _selectedTab = 0;

  // Static Demo Datasets
  final List<Map<String, dynamic>> _demoUpcomingRides = [
    {
      'dateHeader': 'Thu, Jul 09',
      'rides': [
        {
          'bookingNo': '884200261',
          'time': '12:06 PM',
          'pickup': 'Palm Beach International Airport (PBI)',
          'pickupNotes': 'Terminal 1 Exit after baggage claim',
          'dropoff': 'West Palm Beach Marriott',
          'dropoffNotes': 'Main Lobby Entrance',
          'passenger': 'Mohamed El Bakkali',
          'driver': 'Mohamed El Bakkali',
          'vehicle': '48EIML',
          'type': 'SEDAN',
          'price': '150.00',
          'payment': 'Credit Card on File',
          'status': 'CONFIRMED',
        },
        {
          'bookingNo': '884200262',
          'time': '9:30 AM',
          'pickup': '106 Via Quantera',
          'pickupNotes': 'Private Gate Access Code #4920',
          'dropoff': 'PBI Airport Terminal 2',
          'dropoffNotes': 'Departures Dropoff Level',
          'passenger': 'Mohamed El Bakkali',
          'driver': 'Mohamed El Bakkali',
          'vehicle': '48EIML',
          'type': 'SEDAN',
          'price': '120.00',
          'payment': 'Credit Card on File',
          'status': 'CONFIRMED',
        },
      ],
    },
    {
      'dateHeader': 'Tue, Jun 30',
      'rides': [
        {
          'bookingNo': '884200263',
          'time': '5:38 PM',
          'pickup': 'PBI Airport (Palm Beach Intl)',
          'pickupNotes': 'All terminals, Exit after baggage claim',
          'dropoff': 'The Breakers Palm Beach hotel',
          'dropoffNotes': 'County Rd 1, South Palm Beach',
          'passenger': 'Mr. Murray Fulgham',
          'driver': 'Mohamed El Bakkali',
          'vehicle': '48EIML',
          'type': 'SUV',
          'price': '210.00',
          'payment': 'Credit Card on File',
          'status': 'UPCOMING',
        },
      ],
    },
    {
      'dateHeader': 'Mon, Jun 29',
      'rides': [
        {
          'bookingNo': '884200264',
          'time': '8:15 AM',
          'pickup': 'Four Seasons Resort Palm Beach',
          'pickupNotes': 'Valet Stand Pickup',
          'dropoff': 'Boca Raton Executive Airport',
          'dropoffNotes': 'Signature Flight Support FBO',
          'passenger': 'Alexander Wright',
          'driver': 'Mohamed El Bakkali',
          'vehicle': '52K92L',
          'type': 'SPRINTER',
          'price': '280.00',
          'payment': 'Credit Card on File',
          'status': 'CONFIRMED',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> _demoPastRides = [
    {
      'dateHeader': 'Sat, Jun 27',
      'rides': [
        {
          'bookingNo': '884200250',
          'time': '11:20 PM',
          'pickup': 'Tramonti Ristorante Delray Beach',
          'pickupNotes': 'Front entrance valet',
          'dropoff': '900 S Ocean Blvd',
          'dropoffNotes': 'Private Residence Driveway',
          'passenger': 'Mohamed El Bakkali',
          'driver': 'Mohamed El Bakkali',
          'vehicle': '48EIML',
          'type': 'SEDAN/SUV',
          'price': '180.00',
          'payment': 'Credit Card on File',
          'status': 'COMPLETED',
        },
      ],
    },
    {
      'dateHeader': 'Wed, Jun 24',
      'rides': [
        {
          'bookingNo': '884200248',
          'time': '2:15 PM',
          'pickup': 'Miami Beach Convention Center',
          'pickupNotes': 'Hall B Main Entrance',
          'dropoff': 'Fort Lauderdale Airport (FLL)',
          'dropoffNotes': 'Terminal 3 JetBlue Departures',
          'passenger': 'Sarah Jenkins',
          'driver': 'Mohamed El Bakkali',
          'vehicle': '52K92L',
          'type': 'SEDAN',
          'price': '140.00',
          'payment': 'Credit Card on File',
          'status': 'COMPLETED',
        },
      ],
    },
    {
      'dateHeader': 'Sun, Jun 21',
      'rides': [
        {
          'bookingNo': '884200242',
          'time': '7:45 PM',
          'pickup': 'Fontainebleau Miami Beach',
          'pickupNotes': 'Château Tower Lobby',
          'dropoff': 'Miami International Airport (MIA)',
          'dropoffNotes': 'Terminal D Gate 20',
          'passenger': 'Jonathan Reed',
          'driver': 'Mohamed El Bakkali',
          'vehicle': '48EIML',
          'type': 'LIMO STRETCH',
          'price': '165.00',
          'payment': 'Credit Card on File',
          'status': 'COMPLETED',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: "My Rides", notificationCount: 3),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),

            /// CUSTOM TAB BAR
            _buildTabBar(),
            SizedBox(height: 15.h),

            /// RIDES LIST
            Expanded(
              child: _selectedTab == 0
                  ? _buildUpcomingList()
                  : _buildPastList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: const Color(0xff161619),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF24242A)),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          bool isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFD08700)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUpcomingList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _demoUpcomingRides.length,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, groupIndex) {
        final group = _demoUpcomingRides[groupIndex];
        final String dateHeader = group['dateHeader'];
        final List rides = group['rides'];

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
            ...rides.map((ride) {
              return ExecutiveRideCard(
                time: ride['time'],
                pickupLocation: ride['pickup'],
                dropoffLocation: ride['dropoff'],
                passengerOrDriverName: ride['passenger'],
                vehicleInfo: ride['vehicle'],
                vehicleType: ride['type'],
                price: ride['price'],
                paymentType: ride['payment'],
                status: ride['status'],
                onTap: () => _openDetailSheet(ride, dateHeader, isPast: false),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildPastList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _demoPastRides.length,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, groupIndex) {
        final group = _demoPastRides[groupIndex];
        final String dateHeader = group['dateHeader'];
        final List rides = group['rides'];

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
            ...rides.map((ride) {
              return ExecutiveRideCard(
                time: ride['time'],
                pickupLocation: ride['pickup'],
                dropoffLocation: ride['dropoff'],
                passengerOrDriverName: ride['passenger'],
                vehicleInfo: ride['vehicle'],
                vehicleType: ride['type'],
                price: ride['price'],
                paymentType: ride['payment'],
                status: ride['status'],
                onTap: () => _openDetailSheet(ride, dateHeader, isPast: true),
              );
            }),
          ],
        );
      },
    );
  }

  void _openDetailSheet(
    Map<String, dynamic> ride,
    String dateHeader, {
    required bool isPast,
  }) {
    Get.bottomSheet(
      ExecutiveRideDetailSheet(
        title: isPast ? "Completed Ride" : "Upcoming Ride Details",
        bookingNo: ride['bookingNo'],
        dateTimeStr: "$dateHeader • ${ride['time']}",
        pickupLocation: ride['pickup'],
        pickupNotes: ride['pickupNotes'],
        dropoffLocation: ride['dropoff'],
        dropoffNotes: ride['dropoffNotes'],
        passengerName: ride['passenger'],
        driverName: ride['driver'],
        vehicleInfo: ride['vehicle'],
        vehicleType: ride['type'],
        paymentType: ride['payment'],
        amount: ride['price'],
        status: ride['status'],
        actionButtonText: isPast ? null : "View Ride Progress",
        onActionButtonPressed: isPast
            ? null
            : () {
                Get.snackbar(
                  "Ride Progress",
                  "Tracking active route for Booking #${ride['bookingNo']}",
                  backgroundColor: const Color(0xFFD08700),
                  colorText: Colors.white,
                );
              },
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }
}
