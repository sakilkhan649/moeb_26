import 'package:get/get.dart';
import '../../../../Ripositoryes/socket_repository.dart';
import '../../../../Services/user_service.dart';
import '../Model/Chat_model.dart';

class ChatController extends GetxController {
  final SocketRepository socketRepo = Get.find();
  
  var chats = <ChatPreview>[].obs;
  var filteredChats = <ChatPreview>[].obs;
  var searchController = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  Future<void> fetchChats() async {
    try {
      isLoading.value = true;
      final fetchedChats = await socketRepo.getChats();
      chats.assignAll(fetchedChats);
      filteredChats.assignAll(chats);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chats');
    } finally {
      isLoading.value = false;
    }
  }

  void filterChats(String query) {
    searchController.value = query;
    if (query.isEmpty) {
      filteredChats.assignAll(chats);
    } else {
      filteredChats.assignAll(
        chats.where((chat) {
          final currentUserId = Get.find<UserService>().userId;
          final other = chat.getOtherParticipant(currentUserId);
          return other?.name.toLowerCase().contains(query.toLowerCase()) ?? false;
        }).toList(),
      );
    }
  }
}

