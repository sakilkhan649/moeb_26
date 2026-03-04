import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';

class TermPolicyController extends GetxController {
  // All 63 checkboxes as a reactive list
  final RxList<bool> checks = List.generate(63, (_) => false).obs;

  // Validation error flag
  final RxBool showError = false.obs;

  // Toggle a specific checkbox
  void toggleCheck(int index) {
    checks[index] = !checks[index];
    // Clear error if all are now checked
    if (allChecked) {
      showError.value = false;
    }
  }

  // Get observable-like access for a specific checkbox
  bool getCheck(int index) => checks[index];

  // Check if all checkboxes are checked
  bool get allChecked => checks.every((e) => e);

  // Validate — if all checked, trigger the final API call
  void validate() {
    if (!allChecked) {
      showError.value = true;
      return;
    }
    // All agreed → submit all data via single POST /user
    if (Get.isRegistered<SignupController>()) {
      Get.find<SignupController>().submitAll();
    }
  }
}
