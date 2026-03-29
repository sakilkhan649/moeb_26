import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleModel {
  final RxString selectedVehicleType;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController;
  final TextEditingController licensePlateController;

  // New Fields from DocumentsUpload
  final Rx<File?> commercialInsuranceFile = Rx<File?>(null);
  final TextEditingController commercialInsuranceExpireController = TextEditingController();

  final Rx<File?> vehicleRegistrationFile = Rx<File?>(null);
  final TextEditingController vehicleRegistrationExpireController = TextEditingController();

  final Rx<File?> frontViewFile = Rx<File?>(null);
  final Rx<File?> rearViewFile = Rx<File?>(null);
  final Rx<File?> interiorViewFile = Rx<File?>(null);

  VehicleModel({String? initialType})
    : selectedVehicleType = (initialType ?? '').obs,
      makeController = TextEditingController(),
      modelController = TextEditingController(),
      yearController = TextEditingController(),
      colorController = TextEditingController(),
      licensePlateController = TextEditingController();

  factory VehicleModel.fromVehicle(dynamic vehicle) {
    final model = VehicleModel(initialType: vehicle.carType);
    model.makeController.text = vehicle.make;
    model.modelController.text = vehicle.model;
    model.yearController.text = vehicle.year.toString();
    model.colorController.text = vehicle.colorInside;
    model.licensePlateController.text = vehicle.licensePlate;
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      "carType": selectedVehicleType.value,
      "make": makeController.text,
      "model": modelController.text,
      "year": int.tryParse(yearController.text) ?? 0,
      "colorInside": colorController.text, // 👈 same value
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
    commercialInsuranceExpireController.dispose();
    vehicleRegistrationExpireController.dispose();
  }
}
