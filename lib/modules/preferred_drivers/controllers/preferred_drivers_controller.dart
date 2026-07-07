import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';

class FavoriteDriver {
  final String name;
  final double rating;
  final String ratingCount;
  final String imageUrl;
  final String joinedDate;
  final String vehicleName;
  final String languages;
  final String totalRides;
  final String reviewDate;
  final String reviewText;
  final String reviewerName;
  final String reviewerImageUrl;

  FavoriteDriver({
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.imageUrl,
    required this.joinedDate,
    required this.vehicleName,
    required this.languages,
    required this.totalRides,
    required this.reviewDate,
    required this.reviewText,
    required this.reviewerName,
    required this.reviewerImageUrl,
  });
}

class PreferredDriversController extends GetxController {
  final RxList<FavoriteDriver> driversList = <FavoriteDriver>[
    FavoriteDriver(
      name: 'Marcus J.',
      rating: 4.9,
      ratingCount: '(1.2k)',
      imageUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
      joinedDate: 'Oct 2022',
      vehicleName: 'Mercedes-Benz S-Class',
      languages: 'English, Spanish',
      totalRides: '1,248',
      reviewDate: '2 days ago',
      reviewText: 'Excellent service. Marcus was extremely polite and the car was immaculate. Definitely my preferred driver from now on.',
      reviewerName: 'Sarah T.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    ),
    FavoriteDriver(
      name: 'Sarah K.',
      rating: 4.8,
      ratingCount: '(850)',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      joinedDate: 'Jan 2023',
      vehicleName: 'BMW 7 Series',
      languages: 'English, German',
      totalRides: '850',
      reviewDate: '5 days ago',
      reviewText: 'Sarah was very professional and prompt. The ride was extremely comfortable and smooth. Highly recommended!',
      reviewerName: 'Michael P.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
    ),
    FavoriteDriver(
      name: 'David L.',
      rating: 5.0,
      ratingCount: '(2.1k)',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      joinedDate: 'Jun 2021',
      vehicleName: 'Audi A8L',
      languages: 'English, French',
      totalRides: '2,154',
      reviewDate: '1 day ago',
      reviewText: 'David always provides a 5-star experience. Friendly conversation and very clean vehicle. Best driver on the platform!',
      reviewerName: 'John D.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
    ),
    FavoriteDriver(
      name: 'Elena R.',
      rating: 4.9,
      ratingCount: '(420)',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      joinedDate: 'Mar 2023',
      vehicleName: 'Tesla Model S',
      languages: 'English, Russian',
      totalRides: '420',
      reviewDate: '1 week ago',
      reviewText: "Elena's Tesla was super clean and quiet. She is a very safe driver and was extremely polite. Will book again!",
      reviewerName: 'Emily R.',
      reviewerImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
    ),
  ].obs;

  final Rxn<FavoriteDriver> selectedDriver = Rxn<FavoriteDriver>();

  void viewProfile(FavoriteDriver driver) {
    selectedDriver.value = driver;
    Get.toNamed(Routes.preferredDriverProfileView);
  }

  void removeFromFavorites(FavoriteDriver driver) {
    driversList.remove(driver);
    Get.back(); // Return to previous screen
    Get.snackbar(
      "Favorites",
      "${driver.name} removed from favorites",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
