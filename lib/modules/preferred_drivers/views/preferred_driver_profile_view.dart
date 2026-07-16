import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/preferred_drivers_controller.dart';

class PreferredDriverProfileView extends StatelessWidget {
  const PreferredDriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferredDriversController controller =
        Get.find<PreferredDriversController>();
    final chauffeur = controller.selectedChauffeur.value;

    if (chauffeur == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No chauffeur selected.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
        ),
      );
    }

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
      body: Column(
        children: [
          // Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Chauffeur Avatar with Rating Badge
                  Stack(
                    children: [
                      Container(
                        width: 130.w,
                        height: 130.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD08700),
                            width: 2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFD08700,
                              ).withValues(alpha: 0.15),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(65.w),
                          child: Image.network(
                            chauffeur.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD08700),
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
                                chauffeur.rating.toString(),
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
                    chauffeur.name +
                        (chauffeur.nickName != null &&
                                chauffeur.nickName!.isNotEmpty
                            ? ' (${chauffeur.nickName})'
                            : ''),
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFEDB9B), // Soft peach-yellow
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Action Buttons (Start Conversation & Remove from Favorites)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "Start Conversation" Button
                      ElevatedButton(
                        onPressed: () =>
                            controller.startConversation(chauffeur),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD08700),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 12.h,
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Colors.black,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Start Conversation',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // "Remove from Favorites" Button
                      OutlinedButton(
                        onPressed: () =>
                            controller.removeFromFavorites(chauffeur),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFFEDB9B),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.heart_broken_outlined,
                              color: const Color(0xFFFEDB9B),
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Remove from Favorites',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFFEDB9B),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
                          value: chauffeur.companyName,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          title: 'Phone',
                          value: chauffeur.phone,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: chauffeur.email,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.map_outlined,
                          title: 'Service Area',
                          value: chauffeur.serviceArea,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.directions_car_outlined,
                          title: 'Car - Tag',
                          value: chauffeur.carTag,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.translate_outlined,
                          title: 'Languages',
                          value: chauffeur.languages,
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
                          value: chauffeur.zelle,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.payment_outlined,
                          title: 'Venmo',
                          value: chauffeur.venmo,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
                        _buildInfoRow(
                          icon: Icons.monetization_on_outlined,
                          title: 'Cash App',
                          value: chauffeur.cashApp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
                        ),
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

                  // Recent Ratings Title Row
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
                      Text(
                        'View All',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD08700),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Feedback Card Container
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: const Color(0xFFD08700),
                                  size: 16.sp,
                                ),
                              ),
                            ),
                            Text(
                              chauffeur.reviewDate,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD5C4AB),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '"${chauffeur.reviewText}"',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: const Divider(
                            color: Color(0xFF2C2C2C),
                            thickness: 1,
                          ),
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
                                radius: 16.r,
                                backgroundImage: NetworkImage(
                                  chauffeur.reviewerImageUrl,
                                ),
                                backgroundColor: const Color(0xFF27272A),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              chauffeur.reviewerName,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
