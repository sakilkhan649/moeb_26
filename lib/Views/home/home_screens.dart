import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Views/home/ChatPage/ChatPage.dart';
import 'package:moeb_26/Views/home/DealsPage/DealsPage.dart';
import 'package:moeb_26/Views/home/JobOfferPage/JobOfferPage.dart';
import 'package:moeb_26/Views/home/MarketplacePage/MarketplacePage.dart';
import 'package:moeb_26/Views/home/RidesPage/RidesPage.dart';
import 'home_controller.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.put(NavigationController());

    final List<Widget> pages = [
      Jobofferpage(),
      Ridespage(),
      Chatpage(),
      Marketplacepage(),
      Dealspage(),
    ];

    return Scaffold(
      body: Obx(() => pages[navController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Color(0xFF191919), // Background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              5,
              (index) => _buildCustomIcon(index, navController),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomIcon(int index, NavigationController navController) {
    final bool isSelected = navController.currentIndex.value == index;

    return GestureDetector(
      onTap: () => navController.changeIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 45.w,
            width: 45.w,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF000000) : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              _getIconForIndex(index),
              size: 24.sp,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          SizedBox(height: 5.h), // Add some space between icon and label
          Text(
            _getLabelForIndex(index),
            style: TextStyle(
              fontSize: 10.sp,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.work_outline;
      case 1:
        return Icons.directions_car_outlined;
      case 2:
        return Icons.chat_bubble_outline;
      case 3:
        return Icons.shopping_bag_outlined;
      case 4:
        return Icons.local_offer_outlined;
      default:
        return Icons.work_outline;
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Job Offer';
      case 1:
        return 'Rides';
      case 2:
        return 'Chat';
      case 3:
        return 'Marketplace';
      case 4:
        return 'Deals';
      default:
        return '';
    }
  }
}
