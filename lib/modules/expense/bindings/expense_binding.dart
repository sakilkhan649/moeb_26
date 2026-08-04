import 'package:get/get.dart';
import 'package:moeb_26/core/services/expense_service.dart';
import '../controllers/expense_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ExpenseService>()) {
      Get.put(ExpenseService(), permanent: true);
    }
    Get.lazyPut<ExpenseController>(() => ExpenseController());
  }
}
