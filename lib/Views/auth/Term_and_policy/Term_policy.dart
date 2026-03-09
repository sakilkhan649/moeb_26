import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import 'controller/term_policy_controller.dart';

class TermPolicy extends StatelessWidget {
  TermPolicy({super.key});

  final controller = Get.put(TermPolicyController());
  late final SignupController? signupCtrl = Get.isRegistered<SignupController>()
      ? Get.find<SignupController>()
      : null;

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
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                      "This Code of Conduct defines the professional standards required of all chauffeurs operating within the Ekkali Network. Compliance is mandatory.",
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
                              0,
                              "Chauffeurs must wear a full business suit with tie at all times while on duty.",
                            ),
                            _item(
                              1,
                              "Approved suit colors: Black, Navy Blue, or Dark Grey only.",
                            ),
                            _item(
                              2,
                              "Shirts must be clean, pressed, and neutral in color (white or light blue).",
                            ),
                            _item(
                              3,
                              "Shoes must be black dress shoes, clean and polished.",
                            ),
                            _item(
                              4,
                              "Personal grooming must be professional at all times (clean shave or neatly trimmed beard).",
                            ),
                          ],
                        ),

                        // 🚗 FRAGRANCE & HYGIENE
                        _buildSection(
                          title: "FRAGRANCE & HYGIENE",
                          children: [
                            _item(
                              5,
                              "Fragrance must be fragrance-free or extremely light.",
                            ),
                            _item(
                              6,
                              "Strong colognes, perfumes, or scented products are strictly prohibited.",
                            ),
                            _item(
                              7,
                              "Breath must be clean and neutral. Smoking, vaping, or strong food odors prior to service are not permitted.",
                            ),
                          ],
                        ),

                        // 🎁 VEHICLE STANDARDS
                        _buildSection(
                          title: "VEHICLE STANDARDS",
                          children: [
                            _item(
                              8,
                              "Vehicle must be thoroughly cleaned inside and out before every assignment.",
                            ),
                            _item(
                              9,
                              "Interior must be free of odors, trash, stains, or personal items.",
                            ),
                            _item(
                              10,
                              "Windows must be clean; dashboard and seats wiped and presentable.",
                            ),
                            _item(
                              11,
                              "Vehicle must be mechanically sound and fully fueled prior to pickup.",
                            ),
                            _item(
                              12,
                              "No warning or service lights may be displayed during service.",
                            ),
                          ],
                        ),

                        // 🧳 CLIENT AMENITIES
                        _buildSection(
                          title: "CLIENT AMENITIES",
                          children: [
                            _item(
                              13,
                              "Provide bottled water for every client.",
                            ),
                            _item(
                              14,
                              "Provide Apple (Lightning) and Android (USB-C) charging cables.",
                            ),
                            _item(
                              15,
                              "Carry a clean umbrella and offer it in case of rain.",
                            ),
                            _item(
                              16,
                              "Climate control must be set to a comfortable temperature.",
                            ),
                            _item(
                              17,
                              "Music only upon client request (default setting: silence).",
                            ),
                          ],
                        ),

                        // SERVICE & PROFESSIONAL BEHAVIOR
                        _buildSection(
                          title: "SERVICE & PROFESSIONAL BEHAVIOR",
                          children: [
                            _item(
                              18,
                              "Assist clients with luggage unless declined.",
                            ),
                            _item(
                              19,
                              "Open and close vehicle doors when appropriate.",
                            ),
                            _item(
                              20,
                              "Greet clients politely using Mr. / Ms., unless instructed otherwise.",
                            ),
                            _item(
                              21,
                              "Confirm destination quietly and professionally.",
                            ),
                            _item(
                              22,
                              "Maintain a calm, discreet, and respectful demeanor at all times.",
                            ),
                          ],
                        ),

                        // 🚫 STRICT PROFESSIONAL BOUNDARIES
                        _buildSection(
                          title: "STRICT PROFESSIONAL BOUNDARIES",
                          children: [
                            _item(
                              23,
                              "Never discuss politics, religion, or sports with clients.",
                            ),
                            _item(
                              24,
                              "Never argue or express personal opinions.",
                            ),
                            _item(
                              25,
                              "Never provide personal business cards, phone numbers, or social media.",
                            ),
                            _item(
                              26,
                              "Never solicit future business from a client.",
                            ),
                            _item(
                              27,
                              "Always act as a representative exclusively of the assigning company.",
                            ),
                          ],
                        ),

                        // 📵 SAFETY & COMMUNICATION
                        _buildSection(
                          title: "SAFETY & COMMUNICATION",
                          children: [
                            _item(
                              28,
                              "No texting or handheld phone use while driving with a client onboard.",
                            ),
                            _item(
                              29,
                              "Phone use is permitted hands-free only for navigation if necessary.",
                            ),
                            _item(
                              30,
                              "Obey all traffic laws and drive smoothly at all times.",
                            ),
                            _item(
                              31,
                              "Aggressive driving, speeding, or sudden braking is prohibited.",
                            ),
                          ],
                        ),

                        // ⏱️ PUNCTUALITY & RELIABILITY
                        _buildSection(
                          title: "PUNCTUALITY & RELIABILITY",
                          children: [
                            _item(
                              32,
                              "Arrive 10–15 minutes early for every pickup.",
                            ),
                            _item(33, "Monitor flight status when applicable."),
                            _item(
                              34,
                              "Never cancel last-minute except in a true emergency.",
                            ),
                            _item(
                              35,
                              "Immediately inform the company of any delays or issues.",
                            ),
                          ],
                        ),

                        // 🤝 CONFIDENTIALITY & RESPECT
                        _buildSection(
                          title: "CONFIDENTIALITY & RESPECT",
                          children: [
                            _item(
                              36,
                              "All client information is strictly confidential.",
                            ),
                            _item(
                              37,
                              "Do not discuss clients, routes, or conversations with anyone.",
                            ),
                            _item(38, "Respect client privacy at all times."),
                            _item(
                              39,
                              "Treat all clients with equal respect, regardless of status or appearance.",
                            ),
                          ],
                        ),

                        // JOB ACCEPTANCE & RESPONSIBILITY
                        _buildSection(
                          title: "JOB ACCEPTANCE & RESPONSIBILITY",
                          children: [
                            _item(
                              40,
                              "Chauffeurs must carefully review the full job description before accepting any assignment.",
                            ),
                            _item(41, "Pickup and drop-off details."),
                            _item(42, "Date and time."),
                            _item(43, "Vehicle requirements."),
                            _item(44, "Client notes and special instructions."),
                            _item(
                              45,
                              "Once accepted, a job may not be canceled, returned, or declined, except in a true emergency and only with company approval.",
                            ),
                            _item(
                              46,
                              "Job transfers, substitutions, or subcontracting are strictly forbidden without written authorization.",
                            ),
                            _item(
                              47,
                              "The chauffeur who accepts the job is personally responsible for its completion.",
                            ),
                            _item(
                              48,
                              "Unauthorized job swapping or replacement may result in immediate suspension or permanent removal from the Elite Chauffeur Network.",
                            ),
                          ],
                        ),

                        // ASAP Jobs
                        _buildSection(
                          title: "ASAP Jobs",
                          children: [
                            _item(
                              49,
                              "\u201CASAP\u201D means immediate service.",
                            ),
                            _item(
                              50,
                              "Chauffeurs must be on location or within 10 minutes, verified by GPS, to accept the job.",
                            ),
                          ],
                        ),

                        // PAYMENT
                        _buildSection(
                          title: "PAYMENT",
                          children: [
                            _item(
                              51,
                              "Once a job is completed, the job poster must pay the driver within a maximum of 48 hours.",
                            ),
                          ],
                        ),

                        // ⚠️ ENFORCEMENT
                        _buildSection(
                          title: "ENFORCEMENT",
                          children: [
                            _item(52, "Violations may result in: Warning."),
                            _item(
                              53,
                              "Violations may result in: Temporary suspension.",
                            ),
                            _item(
                              54,
                              "Permanent removal from the Elite Chauffeur Network.",
                            ),
                            _item(
                              55,
                              "Repeated low ratings or client complaints will trigger an automatic review.",
                            ),
                          ],
                        ),

                        // DRIVER AGREEMENT
                        _buildSection(
                          title: "DRIVER AGREEMENT",
                          children: [
                            _item(
                              56,
                              "By accepting jobs through the platform, the chauffeur agrees to fully comply with this Ekkali Code of Conduct.",
                            ),
                          ],
                        ),

                        // INDEPENDENT PAYMENT RESPONSIBILITY
                        _buildSection(
                          title: "INDEPENDENT PAYMENT RESPONSIBILITY",
                          children: [
                            _item(
                              57,
                              "I acknowledge and agree that Ekkali Inc. does not collect, process, hold, invoice, or distribute payments of any kind.",
                            ),
                            _item(
                              58,
                              "I acknowledge that I am an independent affiliate, and that Ekkali Inc. is not a payment processor, escrow service, broker, or financial intermediary.",
                            ),
                            _item(
                              59,
                              "I understand and agree that I am solely and exclusively responsible for issuing invoices, collecting payments from clients, and settling payments with other affiliates when applicable.",
                            ),
                            _item(
                              60,
                              "I agree that all payments are handled directly between the parties involved and must be completed using accepted professional methods, including credit/debit card, Zelle, Venmo, Cash App, or ACH transfer.",
                            ),
                            _item(
                              61,
                              " I acknowledge and agree that Ekkali Inc. bears no responsibility or liability for payment disputes, non-payment, delays, chargebacks, or financial losses.",
                            ),
                            _item(
                              62,
                              "I understand that failure to meet payment or professional obligations may result in temporary suspension or permanent removal from the Ekkali platform.",
                            ),
                          ],
                        ),

                        // Validation error message
                        if (controller.showError.value)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      "Please agree to all terms before continuing",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if (signupCtrl != null)
                          Obx(
                            () => CustomButton(
                              text: signupCtrl!.isLoading.value
                                  ? "Submitting..."
                                  : "Continue",
                              onPressed: signupCtrl!.isLoading.value
                                  ? null
                                  : () => controller.validate(),
                            ),
                          ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section builder
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 13.sp, fontWeight: FontWeight.w600),
        SizedBox(height: 20.h),
        ...children,
        SizedBox(height: 20.h),
      ],
    );
  }

  // Single checkbox item
  Widget _item(int index, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () => controller.toggleCheck(index),
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
              _buildCheckbox(index),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextgray(text: text, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Checkbox builder
  Widget _buildCheckbox(int index) {
    final isChecked = controller.checks[index];
    return GestureDetector(
      onTap: () {
        controller.toggleCheck(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: isChecked ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isChecked ? Colors.green : Colors.white,
            width: 2,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 150),
            opacity: isChecked ? 1.0 : 0.0,
            child: Icon(Icons.check, color: Colors.white, size: 18.sp),
          ),
        ),
      ),
    );
  }
}
