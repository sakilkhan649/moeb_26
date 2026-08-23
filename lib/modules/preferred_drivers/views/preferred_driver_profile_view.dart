import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import '../controllers/preferred_drivers_controller.dart';

class PreferredDriverProfileView extends StatelessWidget {
  const PreferredDriverProfileView({super.key});

  String _formatMemberSince(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String _formatReviewDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  void _showAllReviewsBottomSheet(
    BuildContext context,
    PreferredDriversController controller,
    FavoriteChauffeur chauffeur,
  ) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: const Color(0xFF2C2C2C), width: 1),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Reviews & Feedback',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFEDB9B),
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF222226), height: 1),

            // Reviews List with Infinite Scroll
            Expanded(
              child: Obx(() {
                if (controller.isReviewsLoading.value &&
                    controller.reviewsList.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                if (controller.reviewsList.isEmpty) {
                  return Center(
                    child: Text(
                      'No written reviews yet.',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  controller: controller.reviewsScrollController,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  itemCount: controller.reviewsList.length +
                      (controller.isMoreReviewsLoading.value ? 1 : 0),
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (context, index) {
                    if (index == controller.reviewsList.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      );
                    }

                    final review = controller.reviewsList[index];
                    return _buildReviewCard(review);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildReviewCard(ChauffeurReview review) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF2C2C2C), width: 0.98),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating.floor()
                        ? Icons.star
                        : (index < review.rating
                            ? Icons.star_half
                            : Icons.star_border),
                    color: AppColors.primaryColor,
                    size: 15.sp,
                  ),
                ),
              ),
              Text(
                _formatReviewDate(review.reviewedAt),
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.comment.isNotEmpty ? '"${review.comment}"' : 'N/A',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Divider(color: Color(0xFF2C2C2C), thickness: 1),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2C2C2C),
                    width: 0.98,
                  ),
                ),
                child: CircleAvatar(
                  radius: 15.r,
                  backgroundImage:
                      (review.reviewer?.profilePicture.isNotEmpty == true)
                          ? NetworkImage(review.reviewer!.profilePicture)
                          : null,
                  backgroundColor: const Color(0xFF27272A),
                  child: (review.reviewer?.profilePicture.isEmpty ?? true)
                      ? const Icon(
                          Icons.person,
                          size: 15,
                          color: Colors.white54,
                        )
                      : null,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                (review.reviewer?.name.isNotEmpty == true)
                    ? review.reviewer!.name
                    : 'Client',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PreferredDriversController controller =
        Get.find<PreferredDriversController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
          'Favorite Chauffeur',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.5.h),
          child: Divider(
            color: const Color(0xFF1E1E1E),
            height: 1.5.h,
            thickness: 1.5.h,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isProfileLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        final chauffeur = controller.selectedChauffeur.value;

        if (chauffeur == null) {
          return Center(
            child: Text(
              'No chauffeur selected.',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: const Color(0xFF1E1E1E),
          onRefresh: () => controller.fetchUserDetails(chauffeur.id),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                      // Chauffeur Avatar with Rating Badge
                      Stack(
                        children: [
                          Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 2.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.15),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.w),
                              child: chauffeur.imageUrl.isNotEmpty
                                  ? Image.network(
                                      chauffeur.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Center(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white54,
                                          size: 50,
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white54,
                                        size: 50,
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.black,
                                    size: 13.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    chauffeur.rating > 0
                                        ? chauffeur.rating.toString()
                                        : '0.0',
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Chauffeur Name
                      Text(
                        chauffeur.name.isNotEmpty
                            ? chauffeur.name +
                                (chauffeur.nickName != null &&
                                        chauffeur.nickName!.isNotEmpty
                                    ? ' (${chauffeur.nickName})'
                                    : '')
                            : 'N/A',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFEDB9B),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // Verified Chauffeur Badges (or N/A)
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.w,
                        runSpacing: 6.h,
                        children: chauffeur.badges.isNotEmpty
                            ? chauffeur.badges
                                .map(
                                  (badge) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF27272A),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: const Color(0xFF3F3F46),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppColors.primaryColor,
                                          size: 13.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          badge,
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFFD5C4AB),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList()
                            : [
                                Text(
                                  '⭐ Verified Chauffeur',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFD5C4AB),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                      ),
                      SizedBox(height: 18.h),

                      // Action Buttons (Start Conversation & Favorite Toggle)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // "Send a message" Button
                          CustomButton(
                            text: 'Send a message',
                            onPressed: () =>
                                controller.startConversation(chauffeur),
                            icon: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Colors.black,
                              size: 18.sp,
                            ),
                            width: 220.w,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          SizedBox(height: 12.h),

                          // Dynamic Favorite Button (Add or Remove)
                          Builder(
                            builder: (context) {
                              final currentChauffeur =
                                  controller.selectedChauffeur.value ??
                                      chauffeur;
                              final bool isFav = controller
                                      .isInFavorites(currentChauffeur.id) ||
                                  currentChauffeur.isFavorite;

                              if (isFav) {
                                return CustomButton(
                                  text: 'Remove from Favorites',
                                  onPressed: () => controller
                                      .removeFromFavorites(currentChauffeur),
                                  backgroundColor: Colors.transparent,
                                  textColor: const Color(0xFFFEDB9B),
                                  borderColor: const Color(0xFFFEDB9B),
                                  icon: Icon(
                                    Icons.heart_broken_outlined,
                                    color: const Color(0xFFFEDB9B),
                                    size: 18.sp,
                                  ),
                                  width: 220.w,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                );
                              } else {
                                return CustomButton(
                                  text: 'Add to Favorites',
                                  onPressed: () => controller
                                      .addToFavorites(currentChauffeur),
                                  backgroundColor: Colors.transparent,
                                  textColor: AppColors.primaryColor,
                                  borderColor: AppColors.primaryColor,
                                  icon: Icon(
                                    Icons.favorite,
                                    color: AppColors.primaryColor,
                                    size: 18.sp,
                                  ),
                                  width: 220.w,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 28.h),

                      // Chauffeur Information Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Chauffeur Information',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD5C4AB),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Info Card Container
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF2C2C2C),
                            width: 0.98,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.business_outlined,
                              title: 'Company',
                              value: chauffeur.companyName.trim().isNotEmpty
                                  ? chauffeur.companyName
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.badge_outlined,
                              title: 'Role',
                              value: chauffeur.companyRole.trim().isNotEmpty
                                  ? chauffeur.companyRole
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.phone_outlined,
                              title: 'Phone',
                              value: chauffeur.phone.trim().isNotEmpty
                                  ? chauffeur.phone
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              title: 'Email',
                              value: chauffeur.email.trim().isNotEmpty
                                  ? chauffeur.email
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.map_outlined,
                              title: 'Service Area',
                              value: chauffeur.serviceArea.trim().isNotEmpty
                                  ? chauffeur.serviceArea
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.directions_car_outlined,
                              title: 'Car - Tag',
                              value: chauffeur.carTag.trim().isNotEmpty
                                  ? chauffeur.carTag
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.translate_outlined,
                              title: 'Languages',
                              value: chauffeur.languages.trim().isNotEmpty
                                  ? chauffeur.languages
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.calendar_today_outlined,
                              title: 'Member Since',
                              value: chauffeur.joinedDate.trim().isNotEmpty
                                  ? _formatMemberSince(chauffeur.joinedDate)
                                  : 'N/A',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Accepted Payment Methods Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Accepted Payment Methods',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD5C4AB),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Payment Card Container
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF2C2C2C),
                            width: 0.98,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'Zelle',
                              value: chauffeur.zelle.trim().isNotEmpty
                                  ? chauffeur.zelle
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.payment_outlined,
                              title: 'Venmo',
                              value: chauffeur.venmo.trim().isNotEmpty
                                  ? (chauffeur.venmo.startsWith('@')
                                      ? chauffeur.venmo
                                      : '@${chauffeur.venmo}')
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.monetization_on_outlined,
                              title: 'Cash App',
                              value: chauffeur.cashApp.trim().isNotEmpty
                                  ? (chauffeur.cashApp.startsWith('\$')
                                      ? chauffeur.cashApp
                                      : '\$${chauffeur.cashApp}')
                                  : 'N/A',
                            ),
                            _buildDivider(),
                            _buildInfoRow(
                              icon: Icons.credit_card_outlined,
                              title: 'Card Payment',
                              value: chauffeur.cardPaymentAccepted
                                  ? 'Accepted ✅'
                                  : 'Not Accepted ❌',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Recent Ratings & Feedback Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Ratings & Feedback',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD5C4AB),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Obx(() {
                            if (controller.reviewsList.length > 2 ||
                                controller.hasMoreReviews.value) {
                              return GestureDetector(
                                onTap: () => _showAllReviewsBottomSheet(
                                  context,
                                  controller,
                                  chauffeur,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View All',
                                      style: GoogleFonts.inter(
                                        color: AppColors.primaryColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.primaryColor,
                                      size: 18.sp,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Recent Ratings & Feedback Container
                      Obx(() {
                        final reviews = controller.reviewsList;
                        if (controller.isReviewsLoading.value &&
                            reviews.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }

                        if (reviews.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: const Color(0xFF2C2C2C),
                                width: 0.98,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  color: const Color(0xFFD5C4AB),
                                  size: 20.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'No ratings or reviews yet',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFD5C4AB),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final displayList = reviews.take(2).toList();
                        return Column(
                          children: displayList.map((review) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildReviewCard(review),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: const Divider(
        color: Color(0xFF2C2C2C),
        thickness: 1,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFF27272A),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: const Color(0xFFD5C4AB), size: 20.sp),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
