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

  // প্রতিটা checkbox এর জন্য আলাদা আলাদা variable
  // APPEARANCE & DRESS CODE (0-6)
  final check0 = false.obs;
  final check1 = false.obs;
  final check2 = false.obs;
  final check3 = false.obs;
  final check4 = false.obs;
  final check5 = false.obs;
  final check6 = false.obs;

  // VEHICLE STANDARDS (7-11)
  final check7 = false.obs;
  final check8 = false.obs;
  final check9 = false.obs;
  final check10 = false.obs;
  final check11 = false.obs;

  // CLIENT AMENITIES (12-16)
  final check12 = false.obs;
  final check13 = false.obs;
  final check14 = false.obs;
  final check15 = false.obs;
  final check16 = false.obs;

  // SERVICE & PROFESSIONAL BEHAVIOR (17-21)
  final check17 = false.obs;
  final check18 = false.obs;
  final check19 = false.obs;
  final check20 = false.obs;
  final check21 = false.obs;

  // STRICT PROFESSIONAL BOUNDARIES (22-26)
  final check22 = false.obs;
  final check23 = false.obs;
  final check24 = false.obs;
  final check25 = false.obs;
  final check26 = false.obs;

  // SAFETY & COMMUNICATION (27-30)
  final check27 = false.obs;
  final check28 = false.obs;
  final check29 = false.obs;
  final check30 = false.obs;

  // PUNCTUALITY & RELIABILITY (31-34)
  final check31 = false.obs;
  final check32 = false.obs;
  final check33 = false.obs;
  final check34 = false.obs;

  // CONFIDENTIALITY & RESPECT (35-38)
  final check35 = false.obs;
  final check36 = false.obs;
  final check37 = false.obs;
  final check38 = false.obs;

  // ENFORCEMENT (39-40)
  final check39 = false.obs;
  final check40 = false.obs;
  final check41 = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👔 APPEARANCE & DRESS CODE
                      _buildSection(
                        title: "APPEARANCE & DRESS CODE",
                        children: [
                          _item(
                            check0,
                            "Driver must wear a full suit with tie at all times.",
                          ),
                          _item(
                            check1,
                            "Suit colors permitted: Black, Navy Blue, or Dark Grey only.",
                          ),
                          _item(
                            check2,
                            "Shirt must be clean, pressed, and neutral color (white or light blue).",
                          ),
                          _item(
                            check3,
                            "Shoes must be black dress shoes, clean and polished.",
                          ),
                          _item(
                            check4,
                            "Personal grooming must be professional (clean shave or neatly trimmed beard).",
                          ),
                          _item(
                            check5,
                            "Strong colognes, perfumes, or scented products are not permitted.",
                          ),
                          _item(
                            check6,
                            "Breath must be clean and neutral (no smoking, vaping, or strong food odors before service).",
                          ),
                        ],
                      ),

                      // 🚗 VEHICLE STANDARDS
                      _buildSection(
                        title: "VEHICLE STANDARDS",
                        children: [
                          _item(
                            check7,
                            "Vehicle must be clean inside and outside before every job.",
                          ),
                          _item(
                            check8,
                            "Interior must be free of odors, trash, stains, or personal items.",
                          ),
                          _item(
                            check9,
                            "Windows must be clean; dashboard and seats wiped.",
                          ),
                          _item(
                            check10,
                            "Vehicle must be mechanically sound and fueled before pickup.",
                          ),
                          _item(
                            check11,
                            "No warning lights displayed on dashboard during service.",
                          ),
                        ],
                      ),

                      // 🎁 CLIENT AMENITIES
                      _buildSection(
                        title: "CLIENT AMENITIES",
                        children: [
                          _item(
                            check12,
                            "Provide bottled water for every client.",
                          ),
                          _item(
                            check13,
                            "Provide Apple (Lightning) and Android (USB-C) chargers.",
                          ),
                          _item(
                            check14,
                            "Carry a clean umbrella and offer it in case of rain.",
                          ),
                          _item(
                            check15,
                            "Climate control must be set to a comfortable temperature.",
                          ),
                          _item(
                            check16,
                            "Music only upon client request (default: silence).",
                          ),
                        ],
                      ),

                      // 🧳 SERVICE & PROFESSIONAL BEHAVIOR
                      _buildSection(
                        title: "SERVICE & PROFESSIONAL BEHAVIOR",
                        children: [
                          _item(
                            check17,
                            "Always assist clients with luggage unless declined.",
                          ),
                          _item(
                            check18,
                            "Open and close doors when appropriate.",
                          ),
                          _item(
                            check19,
                            "Greet clients politely using Mr. / Ms. unless instructed otherwise.",
                          ),
                          _item(
                            check20,
                            "Confirm destination quietly and professionally.",
                          ),
                          _item(
                            check21,
                            "Always maintain a calm, discreet, and respectful demeanor.",
                          ),
                        ],
                      ),

                      // 🚫 STRICT PROFESSIONAL BOUNDARIES
                      _buildSection(
                        title: "STRICT PROFESSIONAL BOUNDARIES",
                        children: [
                          _item(
                            check22,
                            "Never discuss politics, religion, or sports with clients.",
                          ),
                          _item(
                            check23,
                            "Never argue or express personal opinions.",
                          ),
                          _item(
                            check24,
                            "Never provide a personal business card, phone number, or social media.",
                          ),
                          _item(
                            check25,
                            "Never attempt to solicit future business from the client.",
                          ),
                          _item(
                            check26,
                            "Always act as if you work exclusively for the company that assigned the job.",
                          ),
                        ],
                      ),

                      // 📵 SAFETY & COMMUNICATION
                      _buildSection(
                        title: "SAFETY & COMMUNICATION",
                        children: [
                          _item(
                            check27,
                            "No texting or calling while driving with a client in the vehicle.",
                          ),
                          _item(
                            check28,
                            "Phone may only be used hands-free for navigation if necessary.",
                          ),
                          _item(
                            check29,
                            "Follow all traffic laws and drive smoothly at all times.",
                          ),
                          _item(
                            check30,
                            "No aggressive driving, speeding, or sudden braking.",
                          ),
                        ],
                      ),

                      // ⏱️ PUNCTUALITY & RELIABILITY
                      _buildSection(
                        title: "PUNCTUALITY & RELIABILITY",
                        children: [
                          _item(
                            check31,
                            "Arrive 10–15 minutes early to every pickup.",
                          ),
                          _item(
                            check32,
                            "Monitor flight status when applicable.",
                          ),
                          _item(
                            check33,
                            "Never cancel last minute except in true emergencies.",
                          ),
                          _item(
                            check34,
                            "Inform the company immediately of any delays or issues.",
                          ),
                        ],
                      ),

                      // 🤝 CONFIDENTIALITY & RESPECT
                      _buildSection(
                        title: "CONFIDENTIALITY & RESPECT",
                        children: [
                          _item(
                            check35,
                            "All client information is strictly confidential.",
                          ),
                          _item(
                            check36,
                            "Do not discuss clients, routes, or conversations with anyone.",
                          ),
                          _item(
                            check37,
                            "Respect client privacy at all times.",
                          ),
                          _item(
                            check38,
                            "Treat all clients with equal respect regardless of status or appearance.",
                          ),
                        ],
                      ),

                      // ⚠️ ENFORCEMENT
                      _buildSection(
                        title: "ENFORCEMENT",
                        children: [
                          _item(
                            check39,
                            "Any violation of platform policies may lead to a warning, temporary suspension, or permanent removal from the Elite Chauffeur Network.",
                          ),
                          _item(
                            check40,
                            "Repeated low ratings or complaints lead to automatic review.",
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // শেষ লাইন (checkbox ছাড়া)
                      _buildSection(
                        title: "DRIVER AGREEMENT",
                        children: [
                          _item(
                            check41,
                            "By accepting jobs through the platform, the driver agrees to fully comply with this Elite Driver Code of Conduct.",
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        text: "Continue",
                        onPressed: () {
                          Get.toNamed(Routes.applicationSubmited);
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

  // Section বানানোর function
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

  // একটা item checkbox সহ
  Widget _item(RxBool isChecked, String text) {
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
            // Checkbox
            _buildCheckbox(isChecked),
            SizedBox(width: 10.w),
            // Text
            Expanded(child: CustomTextgray(text: text, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // Checkbox বানানোর function
  Widget _buildCheckbox(RxBool isChecked) {
    return GestureDetector(
      onTap: () {
        isChecked.value = !isChecked.value;
      },
      child: Obx(
        () => AnimatedContainer(
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
      ),
    );
  }
}
