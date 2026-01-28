import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:moeb_26/Utils/app_images.dart';
import 'package:moeb_26/widgets/Custom_Job_Button.dart';
import '../../../widgets/Custom_AppBar.dart';
import 'Job_Bottom_sheet/Job_Bottom_sheet_Tabbar.dart';
import 'Notifications/Notifications_popup.dart';

class Jobofferpage extends StatelessWidget {
  const Jobofferpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(logoPath: AppImages.app_logo, notificationCount: 3),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            CustomJobButton(
              text: "New Job",
              onPressed: () {
                Get.bottomSheet(
                  PostJobBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
