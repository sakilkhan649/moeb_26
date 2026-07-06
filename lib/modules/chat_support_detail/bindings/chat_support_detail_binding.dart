import 'package:get/get.dart';
import '../controllers/chat_support_detail_controller.dart';

class ChatSupportDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupportChatController());
  }
}
