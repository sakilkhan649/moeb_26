import 'package:get/get.dart';
import 'package:moeb_26/modules/chat_community/controllers/chat_community_detail_controller.dart';

class ChatCommunityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunityChatDetailController());
  }
}
