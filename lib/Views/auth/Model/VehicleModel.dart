import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleModel {
  final RxString selectedVehicleType;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController;
  final TextEditingController licensePlateController;

  VehicleModel({String? initialType})
    : selectedVehicleType = (initialType ?? 'Sedan').obs,
      makeController = TextEditingController(),
      modelController = TextEditingController(),
      yearController = TextEditingController(),
      colorController = TextEditingController(),
      licensePlateController = TextEditingController();

  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    licensePlateController.dispose();
  }
}
