import 'package:get/get.dart';

class ServiceAreaModel {
  final String title;
  final List<String> cities;
  final bool isLocked;
  bool isExpanded;

  ServiceAreaModel({
    required this.title,
    required this.cities,
    this.isLocked = false,
    this.isExpanded = false, // Default to false as per new screenshot
  });
}