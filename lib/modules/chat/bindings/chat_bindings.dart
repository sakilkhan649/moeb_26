import 'package:get/get.dart';
import 'package:moeb_26/modules/chat/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}
