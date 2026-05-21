/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import 'package:moeb_26/widgets/CustomText.dart';
import 'package:moeb_26/widgets/CustomTextGary.dart';
import '../../../Utils/app_colors.dart';
import '../../../widgets/CustomButton.dart';
import 'controller/term_policy_controller.dart';

class TermPolicyOld extends StatelessWidget {
  TermPolicyOld({super.key});

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
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller/legal_content_controller.dart';

class TermPolicy extends StatelessWidget {
  TermPolicy({super.key});

  final controller = Get.put(LegalContentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
        title: Obx(() => Text(
          controller.title.value.isEmpty ? "Legal Page" : controller.title.value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (controller.content.value.isEmpty) {
            return Center(
              child: Text(
                "No content available",
                style: GoogleFonts.inter(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: HtmlWidget(
              controller.content.value,
              textStyle: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              customStylesBuilder: (element) {
                if (element.localName == 'h1') {
                  return {'color': 'white', 'font-weight': 'bold', 'font-size': '24px'};
                }
                if (element.localName == 'h2') {
                  return {'color': 'white', 'font-weight': 'bold', 'font-size': '20px'};
                }
                return null;
              },
            ),
          );
        }),
      ),
    );
  }
}
