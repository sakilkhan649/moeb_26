import 'package:flutter/cupertino.dart';
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
    // NavigationController initialize করা হচ্ছে
    final NavigationController navController = Get.put(NavigationController());

    // সব pages এর list যা bottom navigation এ দেখাবে
    final List<Widget> pages = [
      const Jobofferpage(),
      const Ridespage(),
      const Chatpage(),
      const Marketplacepage(),
      const Dealspage(),
    ];

    return Scaffold(
      // Current selected page display করা হচ্ছে
      body: Obx(
            () => pages[navController.currentIndex.value],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Obx(
            () => Container(
              height: 90.h,
          decoration: BoxDecoration(
            color: Color(0xFF191919), // Background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: BottomNavigationBar(
              currentIndex: navController.currentIndex.value,
              onTap: navController.changeIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedFontSize: 12.sp,
              unselectedFontSize: 10.sp,
              items: [
                // Job Offer tab
                BottomNavigationBarItem(
                  icon: _buildIconWithIndicator(
                    Icons.work_outline,
                    0,
                    navController.currentIndex.value,
                  ),
                  activeIcon: _buildIconWithIndicator(
                    Icons.work,
                    0,
                    navController.currentIndex.value,
                  ),
                  label: 'Job Offer',
                ),
                // Rides tab
                BottomNavigationBarItem(
                  icon: _buildIconWithIndicator(
                    Icons.directions_car_outlined,
                    1,
                    navController.currentIndex.value,
                  ),
                  activeIcon: _buildIconWithIndicator(
                    Icons.directions_car,
                    1,
                    navController.currentIndex.value,
                  ),
                  label: 'Rides',
                ),
                // Chat tab
                BottomNavigationBarItem(
                  icon: _buildIconWithIndicator(
                    Icons.chat_bubble_outline,
                    2,
                    navController.currentIndex.value,
                  ),
                  activeIcon: _buildIconWithIndicator(
                    Icons.chat_bubble,
                    2,
                    navController.currentIndex.value,
                  ),
                  label: 'Chat',
                ),
                // Marketplace tab
                BottomNavigationBarItem(
                  icon: _buildIconWithIndicator(
                    Icons.shopping_bag_outlined,
                    3,
                    navController.currentIndex.value,
                  ),
                  activeIcon: _buildIconWithIndicator(
                    Icons.shopping_bag,
                    3,
                    navController.currentIndex.value,
                  ),
                  label: 'Marketplace',
                ),
                // Deals tab
                BottomNavigationBarItem(
                  icon: _buildIconWithIndicator(
                    Icons.local_offer_outlined,
                    4,
                    navController.currentIndex.value,
                  ),
                  activeIcon: _buildIconWithIndicator(
                    Icons.local_offer,
                    4,
                    navController.currentIndex.value,
                  ),
                  label: 'Deals',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildIconWithIndicator(IconData icon, int index, int currentIndex) {
    // Selected কিনা check করা হচ্ছে
    final bool isSelected = currentIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated container যা smooth transition দেয়
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 45.h,
          width: 45.w,
          decoration: BoxDecoration(
            // Selected হলে black background, না হলে transparent
            color: isSelected ? const Color(0xFF000000) : Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          // Icon center এ রাখার জন্য
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24.sp,
            // Selected হলে white, না হলে grey
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}