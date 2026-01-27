import 'package:get/get.dart';

class BookingController extends GetxController {
  var isDeleted = false.obs;

  void deleteItem() {
    isDeleted.value = true;
  }
}
