import 'package:get/get.dart';

class BookingController extends GetxController {
  var isDeleted = false.obs;
  var isJobAcceptanceView = false.obs;

  void deleteItem() {
    isDeleted.value = true;
  }

  void setJobAcceptanceView(bool value) {
    isJobAcceptanceView.value = value;
  }
}
