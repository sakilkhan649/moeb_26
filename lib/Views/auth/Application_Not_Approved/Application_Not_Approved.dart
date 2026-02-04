import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/app_icons.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../../../Core/routs.dart';
import '../../../widgets/Contact_support_popup.dart';
import '../../../widgets/CustomButton.dart';

/// Review Status Screen
/// Shows application submission status with animated steps
class ApplicationNotApproved extends StatelessWidget {
  const ApplicationNotApproved({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w,),
            child: Column(
              children: [
                SizedBox(height: 80.h),

                // Clock Icon with pulse animation
                _buildClockIcon(),

                SizedBox(height: 40.h),

                // Title
                CustomText(
                  text: "Application Not Approved",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(height: 16.h),

                // Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomTextgray(
                    text:
                        "Unfortunately, we couldn't approve your application at this time.",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    color: Color(0xFFBDA3A3),
                  ),
                ),
                SizedBox(height: 30.h),

                // Info Box
                _buildInfoBox(
                  subtitle: "Reason:",
                  subtitleColor: Color(0xFFBDA3A3),

                  title:
                      "Incomplete documents or vehicle not meeting standards",
                  titleColor: Color(0xFFB2BD61),
                ),

                SizedBox(height: 30.h),
                // Info Box
                _buildInfoBox(
                  title:
                      "You can contact our support team at support@elitechauffeur.network for more information or to reapply with updated documents.",
                  titleColor: Color(0xFFFFFFFF),
                ),
                SizedBox(height: 30.h),
                CustomButton(
                  text: "Contact Support",
                  onPressed: () {
                    showContactSupportBottomSheet();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds clock icon with circular background
  Widget _buildClockIcon() {
    return SvgPicture.asset(
      AppIcons.close_icon, // Path to your SVG asset
      fit: BoxFit.contain, // Ensure the SVG fits well within the container
      width: 100.w, // Adjust the icon size within the circle
      height: 100.w, // Adjust the icon size within the circle
    );
  }

  Widget _buildInfoBox({
    required String title,
    String? subtitle,
    required Color titleColor, // Added dynamic color for title
    Color? subtitleColor, // Optional dynamic color for subtitle
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(0xFF1E2939), // Background color of the info box
        borderRadius: BorderRadius.circular(
          16.r,
        ), // Rounded corners// Border styling
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(
                color:
                    subtitleColor ??
                    Colors
                        .white70, // Default to white70 if subtitleColor is not provided
                fontSize: 14, // Subtitle font size
              ),
            ),
          SizedBox(height: 8.h), // Space between subtitle and title
          Text(
            title,
            style: TextStyle(
              color: titleColor, // Use dynamic title color
              fontSize: 16,
              fontWeight: FontWeight.w400, // Title font weight
            ),
          ),
        ],
      ),
    );
  }
}
