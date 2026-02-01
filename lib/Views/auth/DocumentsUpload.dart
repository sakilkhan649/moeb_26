import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Core/routs.dart';
import '../../Utils/app_colors.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomText.dart';
import '../../widgets/CustomTextGary.dart';

class Documentsupload extends StatelessWidget {
  Documentsupload({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.w),
              // Page title
              CustomText(text: "Documents Upload", fontSize: 20.sp),
              SizedBox(height: 7.h),
              //subtitle text
              CustomTextgray(
                text: "Upload required documents for verificationHola",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),

              SizedBox(height: 30.h),

              /// First document License Plate
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIcon(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "License Plate",
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                            Text(
                              "  *",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        CustomTextgray(text: "PDF, JPG, PNG"),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  CustomText(
                    text: "Expire Date",
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildExpireDateField(
                controller: controller,
                hintText: "1 June 2030",
              ),
              SizedBox(height: 16.h),

              /// Second document Hack License
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIcon(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "Hack License",
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                            Text(
                              "  *",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        CustomTextgray(text: "PDF, JPG, PNG"),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  CustomText(
                    text: "Expire Date",
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildExpireDateField(
                controller: controller,
                hintText: "1 June 2030",
              ),
              SizedBox(height: 16.h),

              /// First document Local Permit
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIcon(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        CustomText(
                          text: "Local Permit ",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                        SizedBox(height: 6.h),
                        CustomTextgray(text: "PDF, JPG, PNG"),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  CustomText(
                    text: "Expire Date",
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildExpireDateField(
                controller: controller,
                hintText: "1 June 2030",
              ),
              SizedBox(height: 16.h),

              /// Second document Commercial Insurance
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIcon(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "Commercial Insurance",
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                            Text(
                              "  *",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        CustomTextgray(text: "PDF, JPG, PNG"),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  CustomText(
                    text: "Expire Date",
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildExpireDateField(
                controller: controller,
                hintText: "1 June 2030",
              ),
              SizedBox(height: 16.h),

              /// First document Vehicle Registration
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIcon(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "Vehicle Registration",
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                            Text(
                              "  *",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        CustomTextgray(text: "PDF, JPG, PNG"),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  CustomText(
                    text: "Expire Date",
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildExpireDateField(
                controller: controller,
                hintText: "1 June 2030",
              ),
              SizedBox(height: 16.h),

              /// Second document Upload Headshot
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIcon(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "Upload Headshot",
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                            Text(
                              "  *",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        CustomTextgray(
                          text: "BLACK SUIT TIE WITH WHITE BACKGROUND",
                          fontSize: 7.sp,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              /// Vehicle Photos
              Row(
                children: [
                  CustomText(
                    text: "Vehicle Photos",
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                  Text(
                    " *",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              /// First document Front View
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIconPhoto(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        CustomText(
                          text: "Front View",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              /// First document Rear View
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIconPhoto(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        CustomText(
                          text: "Rear View",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              /// First document Interior View
              _CustomContainer(
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildDocumentIconPhoto(),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        CustomText(
                          text: "Interior View",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ],
                    ),
                    SizedBox(width: 30.w),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Define your onPressed action here
                      },
                      icon: Icon(
                        Icons.file_upload_outlined, // Correct Cupertino icon
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2939),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: CustomTextgray(
                  text:
                      "All documents will be reviewed by our admin team. This process typically takes 24-48 hours. You'll be notified via email once approved.",
                ),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: "Submit Application",
                onPressed: () {
                  // Handle SignIn action, like form validation
                  // if (_formkey.currentState!.validate()) {}
                  Get.toNamed(Routes.termPolicy);
                },
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the custom container with the provided child
  Widget _CustomContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.black200, width: 1),
      ),
      child: child,
    );
  }

  /// Builds the expire date text field with date picker
  Widget _buildExpireDateField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.gray100),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.black200),
        ),
      ),
    );
  }

  /// Builds the document icon with background container
  Widget _buildDocumentIcon() {
    return Container(
      // Icon container with padding
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF364153), width: 1),
        // Dark background for icon
        color: const Color(0xFF1E2939),
        // Rounded corners
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.description_outlined, // Document icon
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }

  /// Builds the document icon with background container
  Widget _buildDocumentIconPhoto() {
    return Container(
      // Icon container with padding
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF364153), width: 1),
        // Dark background for icon
        color: const Color(0xFF1E2939),
        // Rounded corners
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.broken_image_outlined, // Document icon
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }
}
