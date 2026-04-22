import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'Controller/ratings_feedback_controller.dart';
import '../../../../../Utils/app_images.dart';
import '../../../../../widgets/CustomText.dart';
import '../../../../../widgets/Custom_AppBar.dart';

class RatingsFeedback extends StatelessWidget {
  RatingsFeedback({super.key});

  final RatingsFeedbackController controller = Get.put(
    RatingsFeedbackController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(logoPath: AppImages.app_logo, notificationCount: 3),
      body: RefreshIndicator(
        color: const Color(0xFFF1A107),
        onRefresh: () => controller.fetchReviews(),
        child: Obx(() {
          if (controller.isLoading.value && controller.reviews.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF1A107)),
            );
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    // Header Section
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: CustomText(
                              text: "Ratings & Feedback",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Summary Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: const Color(0xFFFBB03B), size: 18.sp),
                            SizedBox(width: 6.w),
                            CustomText(
                              text: "${controller.averageRating.value.toStringAsFixed(1)} / 5.0",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        CustomText(
                          text: "${controller.totalReviews.value} reviews",
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Divider(color: Colors.white24, height: 1.h),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              // Feedback List
              if (controller.reviews.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: Center(
                    child: CustomText(
                      text: "No feedback yet",
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                ListView.builder(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.reviews.length,
                  itemBuilder: (context, index) {
                    final item = controller.reviews[index];
                    return _buildFeedbackCard(
                      rating: item.rating,
                      feedback: item.comment,
                      userName: item.reviewerName,
                      userImage: item.reviewerImage,
                    );
                  },
                ),
            ],
          );
        }),
      ),
    );
  }

  // Feedback Card Widget
  Widget _buildFeedbackCard({
    required int rating,
    required String feedback,
    required String userName,
    required String userImage,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(
          0xFF1E1E1E,
        ), // Reflecting user's preferred card color
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star Rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: index < rating
                    ? const Color(0xFFFBB03B)
                    : Colors.white24,
                size: 22.sp,
              );
            }),
          ),
          SizedBox(height: 16.h),
          // Feedback Text
          CustomText(
            text: feedback,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 20.h),
          // User Profile Row
          Row(
            children: [
              Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: userImage.startsWith('http')
                        ? NetworkImage(userImage)
                        : const AssetImage(AppImages.profile_image)
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: CustomText(
                  text: userName,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
