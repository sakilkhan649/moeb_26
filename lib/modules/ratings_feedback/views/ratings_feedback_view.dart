import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/image_paths.dart';
import '../controllers/ratings_feedback_controller.dart';
import '../../../core/widgets/CustomText.dart';

class RatingsFeedbackView extends StatelessWidget {
  RatingsFeedbackView({super.key});

  final RatingsFeedbackController controller = Get.put(
    RatingsFeedbackController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Ratings & Feedback',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
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
                    SizedBox(height: 15.h),
                    // Summary Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: const Color(0xFFFBB03B),
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            CustomText(
                              text:
                                  "${controller.averageRating.value.toStringAsFixed(1)} / 5.0",
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
