import 'package:get/get.dart';
import '../Model/Chat_model.dart';

class ChatController extends GetxController {
  var chats = <ChatPreview>[].obs;
  var filteredChats = <ChatPreview>[].obs;
  var searchController = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy data based on the image provided
    chats.assignAll([
      ChatPreview(
        name: "Live Chat: Elite Chauffeur",
        lastMessage: "Perfect, see you at 2:30 PM",
        time: "10:30 AM",
        unreadCount: 2,
        avatarPath: "assets/images/app_logo_c.png", // Updated to existing logo
      ),
      ChatPreview(
        name: "Premium Rides LLC",
        lastMessage: "Thanks for accepting the job!",
        time: "Yesterday",
        unreadCount: 0,
        initials: "P",
      ),
      ChatPreview(
        name: "Michael Chen",
        lastMessage: "Is the phone mount still available?",
        time: "Jan 15",
        unreadCount: 1,
        initials: "M",
      ),
    ]);
    filteredChats.assignAll(chats);
  }

  void filterChats(String query) {
    searchController.value = query;
    if (query.isEmpty) {
      filteredChats.assignAll(chats);
    } else {
      filteredChats.assignAll(
        chats
            .where(
              (chat) => chat.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }
}
