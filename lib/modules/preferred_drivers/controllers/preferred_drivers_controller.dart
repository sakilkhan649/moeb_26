import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/data/models/chat_model.dart';
import 'package:moeb_26/data/repositories/socket_repository.dart';
import 'package:moeb_26/core/services/user_service.dart';

class FavoriteChauffeur {
  final String id;
  final String name;
  final String? nickName;
  final String companyName;
  final String carTag;
  final double rating;
  final String ratingCount;
  final String imageUrl;
  final String joinedDate;
  final String vehicleName;
  final String languages;
  final String phone;
  final String email;
  final String serviceArea;
  final String zelle;
  final String venmo;
  final String cashApp;
  final bool cardPaymentAccepted;
  final String reviewDate;
  final String reviewText;
  final String reviewerName;
  final String reviewerImageUrl;

  FavoriteChauffeur({
    required this.id,
    required this.name,
    this.nickName,
    required this.companyName,
    required this.carTag,
    required this.rating,
    required this.ratingCount,
    required this.imageUrl,
    required this.joinedDate,
    required this.vehicleName,
    required this.languages,
    required this.phone,
    required this.email,
    required this.serviceArea,
    required this.zelle,
    required this.venmo,
    required this.cashApp,
    required this.cardPaymentAccepted,
    required this.reviewDate,
    required this.reviewText,
    required this.reviewerName,
    required this.reviewerImageUrl,
  });
}

class PreferredDriversController extends GetxController {
  final RxList<FavoriteChauffeur> chauffeursList = <FavoriteChauffeur>[
    FavoriteChauffeur(
      id: 'marcus_j',
      name: 'Marcus J.',
      nickName: 'Marc',
      companyName: 'Elite Chauffeur Services',
      carTag: 'Mercedes-Benz S580 / NY-77B99',
      rating: 4.9,
      ratingCount: '(1.2k)',
      imageUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
      joinedDate: 'Oct 2022',
      vehicleName: 'Mercedes-Benz S-Class',
      languages: 'English, Spanish',
      phone: '+1 (555) 019-2834',
      email: 'marcus.chauffeur@example.com',
      serviceArea: 'New York Metro Area',
      zelle: 'marcus.zelle@example.com',
      venmo: '@marcus-chauffeur',
      cashApp: '\$MarcusChauffeur',
      cardPaymentAccepted: true,
      reviewDate: '2 days ago',
      reviewText: 'Excellent service. Marcus was extremely polite and the car was immaculate. Definitely my preferred chauffeur from now on.',
      reviewerName: 'Sarah T.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    ),
    FavoriteChauffeur(
      id: 'sarah_k',
      name: 'Sarah K.',
      nickName: null,
      companyName: 'L.A. Prestige Rides',
      carTag: 'BMW 750i / CA-99X88',
      rating: 4.8,
      ratingCount: '(850)',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      joinedDate: 'Jan 2023',
      vehicleName: 'BMW 7 Series',
      languages: 'English, German',
      phone: '+1 (555) 024-8971',
      email: 'sarah.k@example.com',
      serviceArea: 'Los Angeles Area',
      zelle: 'sarah.k@example.com',
      venmo: '@sarah-k-chauffeur',
      cashApp: '\$SarahKChauffeur',
      cardPaymentAccepted: true,
      reviewDate: '5 days ago',
      reviewText: 'Sarah was very professional and prompt. The ride was extremely comfortable and smooth. Highly recommended!',
      reviewerName: 'Michael P.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
    ),
    FavoriteChauffeur(
      id: 'david_l',
      name: 'David L.',
      nickName: 'Dave',
      companyName: 'Windy City Limousine',
      carTag: 'Audi A8 L / IL-44Y55',
      rating: 5.0,
      ratingCount: '(2.1k)',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      joinedDate: 'Jun 2021',
      vehicleName: 'Audi A8L',
      languages: 'English, French',
      phone: '+1 (555) 036-7489',
      email: 'david.l.chauffeur@example.com',
      serviceArea: 'Chicago Area',
      zelle: '+1 (555) 036-7489',
      venmo: '@david-l-chauffeur',
      cashApp: '\$DavidLChauffeur',
      cardPaymentAccepted: true,
      reviewDate: '1 day ago',
      reviewText: 'David always provides a 5-star experience. Friendly conversation and very clean vehicle. Best chauffeur on the platform!',
      reviewerName: 'John D.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
    ),
    FavoriteChauffeur(
      id: 'elena_r',
      name: 'Elena R.',
      nickName: 'El',
      companyName: 'Miami Premium Rides',
      carTag: 'Tesla Model S / FL-88Z77',
      rating: 4.9,
      ratingCount: '(420)',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      joinedDate: 'Mar 2023',
      vehicleName: 'Tesla Model S',
      languages: 'English, Russian',
      phone: '+1 (555) 048-9123',
      email: 'elena.r@example.com',
      serviceArea: 'Miami Metro Area',
      zelle: 'elena.r@example.com',
      venmo: '@elena-r-chauffeur',
      cashApp: '\$ElenaRChauffeur',
      cardPaymentAccepted: false,
      reviewDate: '1 week ago',
      reviewText: "Elena's Tesla was super clean and quiet. She is a very safe chauffeur and was extremely polite. Will book again!",
      reviewerName: 'Emily R.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
    ),
  ].obs;

  final Rxn<FavoriteChauffeur> selectedChauffeur = Rxn<FavoriteChauffeur>();
  final RxString searchQuery = ''.obs;

  List<FavoriteChauffeur> get filteredChauffeursList {
    if (searchQuery.isEmpty) {
      return chauffeursList;
    }
    final query = searchQuery.toLowerCase();
    return chauffeursList.where((chauffeur) {
      return chauffeur.name.toLowerCase().contains(query) ||
          chauffeur.phone.toLowerCase().contains(query) ||
          chauffeur.email.toLowerCase().contains(query);
    }).toList();
  }

  void viewProfile(FavoriteChauffeur chauffeur) {
    selectedChauffeur.value = chauffeur;
    Get.toNamed(Routes.preferredDriverProfileView);
  }

  void removeFromFavorites(FavoriteChauffeur chauffeur) {
    chauffeursList.remove(chauffeur);
    Get.back(); // Return to previous screen
    Get.snackbar(
      "Favorites",
      "${chauffeur.name} removed from favorites",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> startConversation(FavoriteChauffeur chauffeur) async {
    try {
      final SocketRepository socketRepo = Get.find<SocketRepository>();
      final UserService userService = Get.find<UserService>();

      // First, get all chats to see if we already have one with this chauffeur
      final chats = await socketRepo.getChats();
      ChatPreview? existingChat;
      for (var chat in chats) {
        if (chat.participants.any((p) => p.id == chauffeur.id)) {
          existingChat = chat;
          break;
        }
      }

      if (existingChat != null) {
        Get.toNamed(Routes.chatDetailView, arguments: existingChat);
      } else {
        // Try to create a chat
        final newChat = await socketRepo.createChat(chauffeur.id, '');
        if (newChat != null) {
          Get.toNamed(Routes.chatDetailView, arguments: newChat);
        } else {
          // Fallback/Mock to ensure it doesn't break if API doesn't fully support empty jobId
          final fallbackChat = ChatPreview(
            id: 'mock_chat_${chauffeur.id}',
            participants: [
              ChatParticipant(id: userService.userId.isNotEmpty ? userService.userId : 'user_id', name: 'Me'),
              ChatParticipant(
                id: chauffeur.id,
                name: chauffeur.name,
                profilePicture: chauffeur.imageUrl,
                email: chauffeur.email,
              ),
            ],
            createdBy: userService.userId.isNotEmpty ? userService.userId : 'user_id',
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          );
          Get.toNamed(Routes.chatDetailView, arguments: fallbackChat);
        }
      }
    } catch (e) {
      // Fallback/Mock on error
      final UserService userService = Get.find<UserService>();
      final fallbackChat = ChatPreview(
        id: 'mock_chat_${chauffeur.id}',
        participants: [
          ChatParticipant(id: userService.userId.isNotEmpty ? userService.userId : 'user_id', name: 'Me'),
          ChatParticipant(
            id: chauffeur.id,
            name: chauffeur.name,
            profilePicture: chauffeur.imageUrl,
            email: chauffeur.email,
          ),
        ],
        createdBy: userService.userId.isNotEmpty ? userService.userId : 'user_id',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      Get.toNamed(Routes.chatDetailView, arguments: fallbackChat);
    }
  }
}
