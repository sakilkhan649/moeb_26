import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Utils/app_images.dart';
import '../../../../../widgets/CustomText.dart';
import '../../../../../widgets/Custom_AppBar.dart';

class RatingsFeedback extends StatelessWidget {
  const RatingsFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for feedback
    final List<Map<String, dynamic>> feedbackList = [
      {
        "rating": 4,
        "feedback": "Professional Behavior",
        "userName": "John D.",
        "userImage": AppImages.profile_image,
      },
      {
        "rating": 4,
        "feedback": "On-Time Service.",
        "userName": "John D.",
        "userImage": AppImages.profile_image,
      },
      {
        "rating": 4,
        "feedback": "Clean & Comfortable Vehicle.",
        "userName": "John D.",
        "userImage": AppImages.profile_image,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(
        logoPath: AppImages.app_logo,
        notificationCount: 3,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Header Section
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 40.w,
                      ), // Balance for arrow icon
                      child: CustomText(
                        text: "Ratings & Feedback",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            SizedBox(height: 20.h),
            // Feedback List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20.h),
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  final item = feedbackList[index];
                  return _buildFeedbackCard(
                    rating: item['rating'],
                    feedback: item['feedback'],
                    userName: item['userName'],
                    userImage: item['userImage'],
                  );
                },
              ),
            ),
          ],
        ),
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
        ), // Matches the dark card color in the image
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star Rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star,
                color: index < rating ? const Color(0xFFFBB03B) : Colors.white,
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
                    image: AssetImage(userImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              CustomText(
                text: userName,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
