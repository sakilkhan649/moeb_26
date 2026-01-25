import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../../Core/routs.dart';
import '../../Utils/app_colors.dart';
import '../../widgets/CustomButton.dart';

class TermPolicy extends StatelessWidget {
  TermPolicy({super.key});

  /// GetX observable for checkbox state
  var isChecked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👔 APPEARANCE & DRESS CODE
                      _buildSection(
                        title: "👔 APPEARANCE & DRESS CODE",
                        children: [
                          _item(
                            "Driver must wear a full suit with tie at all times.",
                          ),
                          _item(
                            "Suit colors permitted: Black, Navy Blue, or Dark Grey only.",
                          ),
                          _item(
                            "Shirt must be clean, pressed, and neutral color (white or light blue).",
                          ),
                          _item(
                            "Shoes must be black dress shoes, clean and polished.",
                          ),
                          _item(
                            "Personal grooming must be professional (clean shave or neatly trimmed beard).",
                          ),
                          _item(
                            "Strong colognes, perfumes, or scented products are not permitted.",
                          ),
                          _item(
                            "Breath must be clean and neutral (no smoking, vaping, or strong food odors before service).",
                          ),
                        ],
                      ),

                      // 🚗 VEHICLE STANDARDS
                      _buildSection(
                        title: "🚗 VEHICLE STANDARDS",
                        children: [
                          _item(
                            "Vehicle must be clean inside and outside before every job.",
                          ),
                          _item(
                            "Interior must be free of odors, trash, stains, or personal items.",
                          ),
                          _item(
                            "Windows must be clean; dashboard and seats wiped.",
                          ),
                          _item(
                            "Vehicle must be mechanically sound and fueled before pickup.",
                          ),
                          _item(
                            "No warning lights displayed on dashboard during service.",
                          ),
                        ],
                      ),

                      // 🎁 CLIENT AMENITIES
                      _buildSection(
                        title: "🎁 CLIENT AMENITIES",
                        children: [
                          _item("Provide bottled water for every client."),
                          _item(
                            "Provide Apple (Lightning) and Android (USB-C) chargers.",
                          ),
                          _item(
                            "Carry a clean umbrella and offer it in case of rain.",
                          ),
                          _item(
                            "Climate control must be set to a comfortable temperature.",
                          ),
                          _item(
                            "Music only upon client request (default: silence).",
                          ),
                        ],
                      ),

                      // 🧳 SERVICE & PROFESSIONAL BEHAVIOR
                      _buildSection(
                        title: "🧳 SERVICE & PROFESSIONAL BEHAVIOR",
                        children: [
                          _item(
                            "Always assist clients with luggage unless declined.",
                          ),
                          _item("Open and close doors when appropriate."),
                          _item(
                            "Greet clients politely using Mr. / Ms. unless instructed otherwise.",
                          ),
                          _item(
                            "Confirm destination quietly and professionally.",
                          ),
                          _item(
                            "Always maintain a calm, discreet, and respectful demeanor.",
                          ),
                        ],
                      ),

                      // 🚫 STRICT PROFESSIONAL BOUNDARIES
                      _buildSection(
                        title: "🚫 STRICT PROFESSIONAL BOUNDARIES",
                        children: [
                          _item(
                            "Never discuss politics, religion, or sports with clients.",
                          ),
                          _item("Never argue or express personal opinions."),
                          _item(
                            "Never provide a personal business card, phone number, or social media.",
                          ),
                          _item(
                            "Never attempt to solicit future business from the client.",
                          ),
                          _item(
                            "Always act as if you work exclusively for the company that assigned the job.",
                          ),
                        ],
                      ),

                      // 📵 SAFETY & COMMUNICATION
                      _buildSection(
                        title: "📵 SAFETY & COMMUNICATION",
                        children: [
                          _item(
                            "No texting or calling while driving with a client in the vehicle.",
                          ),
                          _item(
                            "Phone may only be used hands-free for navigation if necessary.",
                          ),
                          _item(
                            "Follow all traffic laws and drive smoothly at all times.",
                          ),
                          _item(
                            "No aggressive driving, speeding, or sudden braking.",
                          ),
                        ],
                      ),

                      // ⏱️ PUNCTUALITY & RELIABILITY
                      _buildSection(
                        title: "⏱️ PUNCTUALITY & RELIABILITY",
                        children: [
                          _item("Arrive 10–15 minutes early to every pickup."),
                          _item("Monitor flight status when applicable."),
                          _item(
                            "Never cancel last minute except in true emergencies.",
                          ),
                          _item(
                            "Inform the company immediately of any delays or issues.",
                          ),
                        ],
                      ),

                      // 🤝 CONFIDENTIALITY & RESPECT
                      _buildSection(
                        title: "🤝 CONFIDENTIALITY & RESPECT",
                        children: [
                          _item(
                            "All client information is strictly confidential.",
                          ),
                          _item(
                            "Do not discuss clients, routes, or conversations with anyone.",
                          ),
                          _item("Respect client privacy at all times."),
                          _item(
                            "Treat all clients with equal respect regardless of status or appearance.",
                          ),
                        ],
                      ),

                      // ⚠️ ENFORCEMENT
                      _buildSection(
                        title: "⚠️ ENFORCEMENT",
                        children: [
                          _item(
                            "Any violation of platform policies may lead to a warning, temporary suspension, or permanent removal from the Elite Chauffeur Network.",
                          ),
                          _item(
                            "Repeated low ratings or complaints lead to automatic review.",
                          ),
                        ],
                      ),

                      // DRIVER AGREEMENT Section with Checkbox
                      Row(
                        children: [
                          // Custom Checkbox
                          _buildCheckbox(),
                          SizedBox(width: 12.w),
                          CustomText(
                            text: "DRIVER AGREEMENT",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _item(
                        "By accepting jobs through the platform, the driver agrees to fully comply with this Elite Driver Code of Conduct.",
                      ),
                      SizedBox(height: 30.h),
                      // Bottom Continue Button
                      CustomButton(
                        text: "Continue",
                        onPressed: () {
                          // Handle SignIn action, like form validation
                          // if (_formkey.currentState!.validate()) {}
                          Get.toNamed(Routes.applicationNotApproved);
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds section with title and children
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 16, fontWeight: FontWeight.w600),
        SizedBox(height: 20.h),
        ...children,
        SizedBox(height: 20.h),
      ],
    );
  }

  /// Builds individual policy item
  Widget _item(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.black200, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Check icon
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Color(0xFF364153),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.check, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 10.w),
            // Text
            Expanded(child: CustomTextgray(text: text, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  /// Builds custom checkbox
  Widget _buildCheckbox() {
    return Obx(() {
      return GestureDetector(
        onTap: () => isChecked.value = !isChecked.value,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: isChecked.value ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isChecked.value ? Colors.green : Colors.white,
              width: 2,
            ),
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: isChecked.value ? 1.0 : 0.0,
              child: Icon(Icons.check, color: Colors.white, size: 18.sp),
            ),
          ),
        ),
      );
    });
  }
}
