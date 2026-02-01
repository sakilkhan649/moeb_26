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
  final check42 = false.obs;
  final check43 = false.obs;
  final check44 = false.obs;
  final check45 = false.obs;
  final check46 = false.obs;
  final check47 = false.obs;
  final check48 = false.obs;
  final check49 = false.obs;
  final check50 = false.obs;
  final check51 = false.obs;
  final check52 = false.obs;
  final check53 = false.obs;
  final check54 = false.obs;
  final check55 = false.obs;
  final check56 = false.obs;
  final check57 = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: .center,
                    children: [
                      SizedBox(height: 20.h),
                      Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .center,
                        children: [
                          CustomText(
                            text: "Driver Code of Conduct &",
                            fontSize: 20.sp,
                          ),
                          CustomText(
                            text: "Service Standards",
                            fontSize: 20.sp,
                          ),

                          SizedBox(height: 7.h),

                          //subtitle text
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CustomTextgray(
                                text:
                                    "This Code of Conduct defines the professional standards required of all chauffeurs operating within the Elite Chauffeur Network. Compliance is mandatory.",
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 👔 APPEARANCE & DRESS CODE
                      _buildSection(
                        title: "APPEARANCE & DRESS CODE",
                        children: [
                          _item(
                            check0,
                            "Chauffeurs must wear a full business suit with tie at all times while on duty.",
                          ),
                          _item(
                            check1,
                            "Approved suit colors: Black, Navy Blue, or Dark Grey only.",
                          ),
                          _item(
                            check2,
                            "Shirts must be clean, pressed, and neutral in color (white or light blue).",
                          ),
                          _item(
                            check3,
                            "Shoes must be black dress shoes, clean and polished.",
                          ),
                          _item(
                            check4,
                            "Personal grooming must be professional at all times (clean shave or neatly trimmed beard).",
                          ),
                        ],
                      ),

                      // 🚗 VEHICLE STANDARDS
                      _buildSection(
                        title: "Fragrance & Hygiene",
                        children: [
                          _item(
                            check5,
                            "Fragrance must be fragrance-free or extremely light.",
                          ),
                          _item(
                            check6,
                            "Strong colognes, perfumes, or scented products are strictly prohibited.",
                          ),
                          _item(
                            check7,
                            "Breath must be clean and neutral. Smoking, vaping, or strong food odors prior to service are not permitted.",
                          ),
                        ],
                      ),

                      // 🎁 CLIENT AMENITIES
                      _buildSection(
                        title: "VEHICLE STANDARDS",
                        children: [
                          _item(
                            check8,
                            "Vehicle must be thoroughly cleaned inside and out before every assignment.",
                          ),
                          _item(
                            check9,
                            "Interior must be free of odors, trash, stains, or personal items.",
                          ),
                          _item(
                            check10,
                            "Windows must be clean; dashboard and seats wiped and presentable.",
                          ),
                          _item(
                            check11,
                            "Vehicle must be mechanically sound and fully fueled prior to pickup.",
                          ),
                          _item(
                            check12,
                            "No warning or service lights may be displayed during service.",
                          ),
                        ],
                      ),

                      // 🧳 SERVICE & PROFESSIONAL BEHAVIOR
                      _buildSection(
                        title: "CLIENT AMENITIES",
                        children: [
                          _item(
                            check13,
                            "Provide bottled water for every client.",
                          ),
                          _item(
                            check14,
                            "Provide Apple (Lightning) and Android (USB-C) charging cables.",
                          ),
                          _item(
                            check15,
                            "Carry a clean umbrella and offer it in case of rain.",
                          ),
                          _item(
                            check16,
                            "Climate control must be set to a comfortable temperature.",
                          ),
                          _item(
                            check17,
                            "Music only upon client request (default setting: silence).",
                          ),
                        ],
                      ),

                      // 🚫 STRICT PROFESSIONAL BOUNDARIES
                      _buildSection(
                        title: "SERVICE & PROFESSIONAL BEHAVIOR",
                        children: [
                          _item(
                            check18,
                            "Assist clients with luggage unless declined.",
                          ),
                          _item(
                            check19,
                            "Open and close vehicle doors when appropriate.",
                          ),
                          _item(
                            check20,
                            "Greet clients politely using Mr. / Ms., unless instructed otherwise.",
                          ),
                          _item(
                            check21,
                            "Confirm destination quietly and professionally.",
                          ),
                          _item(
                            check22,
                            "Maintain a calm, discreet, and respectful demeanor at all times.",
                          ),
                        ],
                      ),

                      // 📵 SAFETY & COMMUNICATION
                      _buildSection(
                        title: "STRICT PROFESSIONAL BOUNDARIES",
                        children: [
                          _item(
                            check23,
                            "Never discuss politics, religion, or sports with clients.",
                          ),
                          _item(
                            check24,
                            "Never argue or express personal opinions.",
                          ),
                          _item(
                            check25,
                            "Never provide personal business cards, phone numbers, or social media.",
                          ),
                          _item(
                            check26,
                            "Never solicit future business from a client.",
                          ),
                          _item(
                            check27,
                            "Always act as a representative exclusively of the assigning company.",
                          ),
                        ],
                      ),

                      // ⏱️ PUNCTUALITY & RELIABILITY
                      _buildSection(
                        title: "SAFETY & COMMUNICATION",
                        children: [
                          _item(
                            check28,
                            "No texting or handheld phone use while driving with a client onboard.",
                          ),
                          _item(
                            check29,
                            "Phone use is permitted hands-free only for navigation if necessary.",
                          ),
                          _item(
                            check30,
                            "Obey all traffic laws and drive smoothly at all times.",
                          ),
                          _item(
                            check31,
                            "Aggressive driving, speeding, or sudden braking is prohibited.",
                          ),
                        ],
                      ),

                      // 🤝 CONFIDENTIALITY & RESPECT
                      _buildSection(
                        title: "PUNCTUALITY & RELIABILITY",
                        children: [
                          _item(
                            check32,
                            "Arrive 10–15 minutes early for every pickup.",
                          ),
                          _item(
                            check33,
                            "Monitor flight status when applicable.",
                          ),
                          _item(
                            check34,
                            "Never cancel last-minute except in a true emergency.",
                          ),
                          _item(
                            check35,
                            "Immediately inform the company of any delays or issues.",
                          ),
                        ],
                      ),

                      // ⚠️ ENFORCEMENT
                      _buildSection(
                        title: "CONFIDENTIALITY & RESPECT",
                        children: [
                          _item(
                            check36,
                            "All client information is strictly confidential.",
                          ),
                          _item(
                            check37,
                            "Do not discuss clients, routes, or conversations with anyone.",
                          ),
                          _item(
                            check38,
                            "Respect client privacy at all times.",
                          ),
                          _item(
                            check39,
                            "Treat all clients with equal respect, regardless of status or appearance.",
                          ),
                        ],
                      ),

                      // ⚠️ ENFORCEMENT
                      _buildSection(
                        title: "JOB ACCEPTANCE & RESPONSIBILITY",
                        children: [
                          _item(
                            check40,
                            "Chauffeurs must carefully review the full job description before accepting any assignment.",
                          ),
                          _item(check41, "Pickup and drop-off details."),
                          _item(check42, "Date and time."),
                          _item(check43, "Vehicle requirements."),
                          _item(
                            check44,
                            "Client notes and special instructions.",
                          ),
                          _item(
                            check45,
                            "Once accepted, a job may not be canceled, returned, or declined, except in a true emergency and only with company approval.",
                          ),
                          _item(
                            check46,
                            "Job transfers, substitutions, or subcontracting are strictly forbidden without written authorization.",
                          ),
                          _item(
                            check47,
                            "The chauffeur who accepts the job is personally responsible for its completion.",
                          ),
                          _item(
                            check48,
                            "Unauthorized job swapping or replacement may result in immediate suspension or permanent removal from the Elite Chauffeur Network.",
                          ),
                        ],
                      ),
                      // ⚠️ ENFORCEMENT
                      _buildSection(
                        title: "ASAP Jobs",
                        children: [
                          _item(check49, "“ASAP” means immediate service."),
                          _item(
                            check50,
                            "Chauffeurs must be on location or within 10 minutes, verified by GPS, to accept the job.",
                          ),
                        ],
                      ),
                      // শেষ লাইন (checkbox ছাড়া)
                      _buildSection(
                        title: "Payment",
                        children: [
                          _item(
                            check51,
                            "Once a job is completed, the job poster must pay the driver within a maximum of 48 hours.",
                          ),
                        ],
                      ),
                      // ⚠️ ENFORCEMENT
                      _buildSection(
                        title: "ENFORCEMENT",
                        children: [
                          _item(check52, "Violations may result in: Warning."),
                          _item(
                            check53,
                            "Violations may result in: Temporary suspension.",
                          ),
                          _item(
                            check54,
                            "Permanent removal from the Elite Chauffeur Network.",
                          ),
                          _item(
                            check55,
                            "Repeated low ratings or client complaints will trigger an automatic review.",
                          ),
                        ],
                      ),
                      // শেষ লাইন (checkbox ছাড়া)
                      _buildSection(
                        title: "DRIVER AGREEMENT",
                        children: [
                          _item(
                            check56,
                            "By accepting jobs through the platform, the chauffeur agrees to fully comply with this Elite Chauffeur Network Driver Code of Conduct.",
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
                      SizedBox(height: 60.h),
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
        CustomText(text: title, fontSize: 16.sp, fontWeight: FontWeight.w600),
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
            Expanded(
              child: CustomTextgray(text: text, fontSize: 13.sp),
            ),
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
