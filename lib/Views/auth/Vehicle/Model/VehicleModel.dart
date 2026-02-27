import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleModel {
  final RxString selectedVehicleType;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController; // 👈 একটাই
  final TextEditingController licensePlateController;

  VehicleModel({String? initialType})
      : selectedVehicleType = (initialType ?? '').obs,
        makeController = TextEditingController(),
        modelController = TextEditingController(),
        yearController = TextEditingController(),
        colorController = TextEditingController(),
        licensePlateController = TextEditingController();

  Map<String, dynamic> toJson() {
    return {
      "carType": selectedVehicleType.value,
      "make": makeController.text,
      "model": modelController.text,
      "year": int.tryParse(yearController.text) ?? 0,
      "colorInside": colorController.text,  // 👈 same value
      "colorOutside": colorController.text, // 👈 same value
      "licensePlate": licensePlateController.text,
    };
  }

  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    licensePlateController.dispose();
  }
}