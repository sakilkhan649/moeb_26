import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RideModel {
  final String dateTime;
  final String vehicleType;
  final String pickupLocation;
  final String dropoffLocation;
  final String pickupPayment;
  final String pickupAmount;
  final String driverName;
  final String companyName;
  final Color vehicleTypeColor;

  RideModel({
    required this.dateTime,
    required this.vehicleType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupPayment,
    required this.pickupAmount,
    required this.driverName,
    required this.companyName,
    required this.vehicleTypeColor,
  });
}

class RidesController extends GetxController {
  var selectedTab = 0.obs; // Default to Upcoming

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map && Get.arguments.containsKey('ridesTab')) {
      selectedTab.value = Get.arguments['ridesTab'];
    }
  }

  var upcomingRides = <RideModel>[
    RideModel(
      dateTime: "Wed, Jan 21 - 10:00 AM",
      vehicleType: "SUV",
      pickupLocation: "Gulshan 2",
      dropoffLocation: "Banani",
      pickupPayment: "Collect",
      pickupAmount: "\$150",
      driverName: "Zahid",
      companyName: "ELITE",
      vehicleTypeColor: Colors.blue,
    ),
  ].obs;

  var pastRides = <RideModel>[
    RideModel(
      dateTime: "SUN, JAN 20 - 8:30 AM",
      vehicleType: "SEDAN",
      pickupLocation: "Dhaka",
      dropoffLocation: "Barisal",
      pickupPayment: "Collect",
      pickupAmount: "\$125",
      driverName: "Sadat",
      companyName: "SADAX",
      vehicleTypeColor: Colors.red,
    ),
  ].obs;

  var pendingRides = <RideModel>[
    RideModel(
      dateTime: "Tue, Jan 20 - 08:00 AM",
      vehicleType: "SEDAN",
      pickupLocation: "Dhaka",
      dropoffLocation: "Barisal",
      pickupPayment: "Collect",
      pickupAmount: "\$125",
      driverName: "Sadat",
      companyName: "SADAX",
      vehicleTypeColor: Colors.red,
    ),
  ].obs;

  List<RideModel> get currentRides {
    if (selectedTab.value == 0) return upcomingRides;
    if (selectedTab.value == 1) return pastRides;
    return pendingRides;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
