import 'package:get/get.dart';
import '../../../../Services/serviceAreas_service.dart';
import '../Model/ServiceAreaModel.dart';

class ServiceAreaController extends GetxController {
  final ServiceAreasService _serviceAreasService = Get.put(ServiceAreasService());

  var serviceAreas = <ServiceAreaModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServiceAreas();
  }

  Future<void> fetchServiceAreas() async {
    try {
      isLoading.value = true;
      final response = await _serviceAreasService.getAllServiceAreas();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data['data'];
        final items = data.map((json) => ServiceAreaModel.fromJson(json)).toList();
        serviceAreas.assignAll(items);
      }
    } catch (e) {
      print("Error fetching service areas: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Function to toggle the expanded state of a service area
  void toggleExpansion(int index) {
    serviceAreas[index].isExpanded = !serviceAreas[index].isExpanded;
    serviceAreas.refresh(); // Notify Rx listeners
  }
}
