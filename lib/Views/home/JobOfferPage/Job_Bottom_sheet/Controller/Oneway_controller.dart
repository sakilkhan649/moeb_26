import 'package:get/get.dart';

class OnewayController extends GetxController {
  var selectedRole = 'No Collect'.obs;
  var roles = ['No Collect', 'Collect'].obs;

  // Function to pick the role
  void pickRole(String role) {
    selectedRole.value = role;
  }
}