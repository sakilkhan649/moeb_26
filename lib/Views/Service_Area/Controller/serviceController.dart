

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/ServiceAreaModel.dart';


class ServiceAreaController extends GetxController {
  // Dummy data representing the service areas shown in the screenshot
  List<ServiceAreaModel> serviceAreas = [
    ServiceAreaModel(
      title: 'Florida',
      cities: [
        'Miami, FL',
        'Orlando, FL',
        'Palm Beach, FL',
        'Fort Lauderdale, FL',
        'Naples, FL',
        'Tampa, FL',
      ],
      isExpanded: true, // Initially expanded as per screenshot example
    ),
    ServiceAreaModel(
      title: 'Texas',
      cities: ['Austin, TX', 'Dallas, TX', 'Houston, TX'],
      isLocked: true,
    ),
    ServiceAreaModel(
      title: 'New York',
      cities: ['NewYork, NY'],
      isLocked: true,
    ),
    ServiceAreaModel(
      title: 'Massachusetts',
      cities: ['Boston, MA'],
      isLocked: true,
    ),
    ServiceAreaModel(
      title: 'District of Columbia',
      cities: ['Washington DC,DC'],
      isLocked: true,
    ),
    ServiceAreaModel(title: 'Georgia', cities: ['Atlanta, GA'], isLocked: true),
    ServiceAreaModel(
      title: 'Nevada',
      cities: ['Las Vegas, NV'],
      isLocked: true,
    ),
    ServiceAreaModel(
      title: 'Washington',
      cities: ['Seattle, WA'],
      isLocked: true,
    ),
  ];

  // Function to toggle the expanded state of a service area
  void toggleExpansion(int index) {
    serviceAreas[index].isExpanded = !serviceAreas[index].isExpanded;
    update(); // Notify listeners to rebuild the UI
  }
}
