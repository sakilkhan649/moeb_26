import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/modules/bottom_nab_bar/controllers/bottom_nabbar_controller.dart';
import 'package:moeb_26/modules/chat/views/chat_view.dart';
import 'package:moeb_26/modules/deals/views/deals_view.dart';
import 'package:moeb_26/modules/jobs_offers/views/Job_offer_view.dart';
import 'package:moeb_26/modules/market_place/views/market_place_view.dart';
import 'package:moeb_26/modules/rides/views/rides_view.dart';

class BottomNabbarView extends StatelessWidget {
  BottomNabbarView({super.key});

  final List<Widget> pages = [
    JobOfferView(),
    RidesView(),
    ChatView(),
    MarketPlaceView(),
    DealsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.find<NavigationController>();

    return SafeArea(
      child: Scaffold(
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
            child: SvgPicture.asset(
              _getSvgForIndex(index),
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.grey,
                BlendMode.srcIn,
              ),
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

  String _getSvgForIndex(int index) {
    switch (index) {
      case 0:
        return AppIcons.job_offer_icon;
      case 1:
        return AppIcons.rides_icon;
      case 2:
        return AppIcons.chats_icon;
      case 3:
        return AppIcons.marketplace_icon;
      case 4:
        return AppIcons.deals_icon;
      default:
        return '';
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
