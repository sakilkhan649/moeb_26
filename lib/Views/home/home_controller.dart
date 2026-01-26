import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Reactive variable to track the selected index in the bottom navigation bar
  var currentIndex = 0.obs;  // Default to the first item (Job Offer)

  // Method to change the selected index
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
