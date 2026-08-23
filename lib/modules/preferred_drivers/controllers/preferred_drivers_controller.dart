import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/services/api_client.dart';
import 'package:moeb_26/core/services/user_service.dart';
import 'package:moeb_26/data/models/chat_model.dart';
import 'package:moeb_26/data/repositories/favorite_chauffeur_repository.dart';
import 'package:moeb_26/data/repositories/socket_repository.dart';

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
  final bool isFavorite;

  FavoriteChauffeur({
    required this.id,
    required this.name,
    this.nickName,
    required this.companyName,
    this.carTag = '',
    required this.rating,
    required this.ratingCount,
    required this.imageUrl,
    this.joinedDate = '',
    this.vehicleName = '',
    this.languages = '',
    this.phone = '',
    this.email = '',
    required this.serviceArea,
    this.zelle = '',
    this.venmo = '',
    this.cashApp = '',
    this.cardPaymentAccepted = false,
    this.reviewDate = '',
    this.reviewText = '',
    this.reviewerName = '',
    this.reviewerImageUrl = '',
    this.isFavorite = true,
  });

  factory FavoriteChauffeur.fromJson(Map<String, dynamic> json) {
    final double ratingVal = (json['averageRating'] is num)
        ? (json['averageRating'] as num).toDouble()
        : double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0.0;

    final int reviewsVal = (json['totalReviews'] is int)
        ? json['totalReviews']
        : int.tryParse(json['totalReviews']?.toString() ?? '0') ?? 0;

    return FavoriteChauffeur(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Chauffeur',
      phone: json['phone']?.toString() ?? '',
      serviceArea: json['serviceArea']?.toString() ?? '',
      companyName: json['company']?.toString() ??
          json['companyName']?.toString() ??
          'Elite Services',
      imageUrl: json['profilePicture']?.toString() ?? '',
      rating: ratingVal,
      ratingCount: '($reviewsVal)',
      isFavorite: json['isFavorite'] == true,
      email: json['email']?.toString() ?? '',
      carTag: json['carTag']?.toString() ?? '',
      languages: json['languages'] is List
          ? (json['languages'] as List).join(', ')
          : json['languages']?.toString() ?? 'English',
    );
  }
}

class PreferredDriversController extends GetxController {
  late final FavoriteChauffeurRepo _favoriteRepo;

  // Tab 1: My Favorites
  final RxList<FavoriteChauffeur> chauffeursList = <FavoriteChauffeur>[].obs;
  final Rxn<FavoriteChauffeur> selectedChauffeur = Rxn<FavoriteChauffeur>();
  final RxString searchQuery = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxnString nextCursor = RxnString();
  final RxBool hasMore = false.obs;

  final ScrollController scrollController = ScrollController();

  // Tab 2: Find Chauffeurs (Global Platform Directory)
  final RxList<FavoriteChauffeur> globalChauffeursList =
      <FavoriteChauffeur>[].obs;
  final RxString globalSearchQuery = ''.obs;

  final RxBool isGlobalLoading = false.obs;
  final RxBool isGlobalMoreLoading = false.obs;
  final RxnString globalNextCursor = RxnString();
  final RxBool globalHasMore = false.obs;

  final ScrollController globalScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _favoriteRepo = Get.isRegistered<FavoriteChauffeurRepo>()
        ? Get.find<FavoriteChauffeurRepo>()
        : Get.put(FavoriteChauffeurRepo(apiClient: Get.find<ApiClient>()));

    fetchFavorites(isRefresh: true);
    fetchGlobalChauffeurs(isRefresh: true);

    scrollController.addListener(_onScroll);
    globalScrollController.addListener(_onGlobalScroll);

    // Pure Server-side Search with 400ms Debounce for Tab 1 (Favorites)
    debounce(
      searchQuery,
      (_) => fetchFavorites(isRefresh: true),
      time: const Duration(milliseconds: 400),
    );

    // Pure Server-side Search with 400ms Debounce for Tab 2 (Global Directory)
    debounce(
      globalSearchQuery,
      (_) => fetchGlobalChauffeurs(isRefresh: true),
      time: const Duration(milliseconds: 400),
    );
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        hasMore.value &&
        !isMoreLoading.value &&
        !isLoading.value) {
      loadMoreFavorites();
    }
  }

  void _onGlobalScroll() {
    if (globalScrollController.position.pixels >=
            globalScrollController.position.maxScrollExtent - 200 &&
        globalHasMore.value &&
        !isGlobalMoreLoading.value &&
        !isGlobalLoading.value) {
      loadMoreGlobalChauffeurs();
    }
  }

  // ===================== TAB 1: FAVORITES API (SERVER-SIDE) =====================
  Future<void> fetchFavorites({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
      nextCursor.value = null;
      hasMore.value = false;
    }

    try {
      final query = searchQuery.value.trim();
      final response = await _favoriteRepo.getFavorites(
        limit: 10,
        cursor: isRefresh ? null : nextCursor.value,
        searchTerm: query.isNotEmpty ? query : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data?['data'] ?? [];
        final items =
            dataList.map((e) => FavoriteChauffeur.fromJson(e)).toList();

        final cursorData = response.data?['cursor'];
        if (cursorData != null) {
          nextCursor.value = cursorData['nextCursor'];
          hasMore.value = cursorData['hasMore'] == true;
        } else {
          hasMore.value = false;
        }

        if (isRefresh) {
          chauffeursList.assignAll(items);
        } else {
          chauffeursList.addAll(items);
        }
      }
    } catch (e) {
      debugPrint("Error fetching favorite chauffeurs: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> loadMoreFavorites() async {
    if (!hasMore.value || isMoreLoading.value || nextCursor.value == null) {
      return;
    }
    isMoreLoading.value = true;
    await fetchFavorites(isRefresh: false);
  }

  // Pure Server-side Results
  List<FavoriteChauffeur> get filteredChauffeursList => chauffeursList;

  // ===================== TAB 2: GLOBAL CHAUFFEURS API (SERVER-SIDE) =====================
  Future<void> fetchGlobalChauffeurs({bool isRefresh = false}) async {
    if (isRefresh) {
      isGlobalLoading.value = true;
      globalNextCursor.value = null;
      globalHasMore.value = false;
    }

    try {
      final query = globalSearchQuery.value.trim();
      final response = await _favoriteRepo.getAllChauffeurs(
        limit: 10,
        cursor: isRefresh ? null : globalNextCursor.value,
        searchTerm: query.isNotEmpty ? query : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> dataList = response.data?['data'] ?? [];
        final items =
            dataList.map((e) => FavoriteChauffeur.fromJson(e)).toList();

        final cursorData = response.data?['cursor'];
        if (cursorData != null) {
          globalNextCursor.value = cursorData['nextCursor'];
          globalHasMore.value = cursorData['hasMore'] == true;
        } else {
          globalHasMore.value = false;
        }

        if (isRefresh) {
          globalChauffeursList.assignAll(items);
        } else {
          globalChauffeursList.addAll(items);
        }
      }
    } catch (e) {
      debugPrint("Error fetching all chauffeurs: $e");
    } finally {
      isGlobalLoading.value = false;
      isGlobalMoreLoading.value = false;
    }
  }

  Future<void> loadMoreGlobalChauffeurs() async {
    if (!globalHasMore.value ||
        isGlobalMoreLoading.value ||
        globalNextCursor.value == null) {
      return;
    }
    isGlobalMoreLoading.value = true;
    await fetchGlobalChauffeurs(isRefresh: false);
  }

  // Pure Server-side Results
  List<FavoriteChauffeur> get filteredGlobalResults => globalChauffeursList;

  bool isInFavorites(String id) => chauffeursList.any((c) => c.id == id);

  Future<void> addToFavorites(FavoriteChauffeur chauffeur) async {
    if (!isInFavorites(chauffeur.id)) {
      try {
        final response = await _favoriteRepo.addFavorite(chauffeur.id);
        if (response.statusCode == 200 || response.statusCode == 201) {
          chauffeursList.add(chauffeur);
          Get.snackbar(
            "Added to Favorites",
            response.data?['message'] ??
                "${chauffeur.name} added to your favorites!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF1E1E1E),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            "Notice",
            response.data?['message'] ?? "Could not add to favorites",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF1E1E1E),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        debugPrint("Error adding to favorites: $e");
      }
    }
  }

  void viewProfile(FavoriteChauffeur chauffeur) {
    selectedChauffeur.value = chauffeur;
    Get.toNamed(Routes.preferredDriverProfileView);
  }

  void removeFromFavorites(FavoriteChauffeur chauffeur) {
    chauffeursList.remove(chauffeur);
    Get.back();
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
        final newChat = await socketRepo.createChat(chauffeur.id, '');
        if (newChat != null) {
          Get.toNamed(Routes.chatDetailView, arguments: newChat);
        } else {
          final fallbackChat = ChatPreview(
            id: 'mock_chat_${chauffeur.id}',
            participants: [
              ChatParticipant(
                id: userService.userId.isNotEmpty
                    ? userService.userId
                    : 'user_id',
                name: 'Me',
              ),
              ChatParticipant(
                id: chauffeur.id,
                name: chauffeur.name,
                profilePicture: chauffeur.imageUrl,
                email: chauffeur.email,
              ),
            ],
            createdBy: userService.userId.isNotEmpty
                ? userService.userId
                : 'user_id',
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          );
          Get.toNamed(Routes.chatDetailView, arguments: fallbackChat);
        }
      }
    } catch (e) {
      final UserService userService = Get.find<UserService>();
      final fallbackChat = ChatPreview(
        id: 'mock_chat_${chauffeur.id}',
        participants: [
          ChatParticipant(
            id: userService.userId.isNotEmpty ? userService.userId : 'user_id',
            name: 'Me',
          ),
          ChatParticipant(
            id: chauffeur.id,
            name: chauffeur.name,
            profilePicture: chauffeur.imageUrl,
            email: chauffeur.email,
          ),
        ],
        createdBy: userService.userId.isNotEmpty
            ? userService.userId
            : 'user_id',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      Get.toNamed(Routes.chatDetailView, arguments: fallbackChat);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    globalScrollController.dispose();
    super.onClose();
  }
}
