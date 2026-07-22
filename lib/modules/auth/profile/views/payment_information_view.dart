import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/core/widgets/Custom_AppBar.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';

class PaymentInformationView extends StatelessWidget {
  const PaymentInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Payment Methods & Payouts',
        showBackButton: true,
        showActions: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configure Accepted Payment Channels',
                style: GoogleFonts.inter(
                  color: const Color(0xFFD5C4AB),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),

              // Zelle
              _buildInputField(
                label: 'Zelle Email / Phone',
                controller: controller.zelleController,
                hint: 'e.g. pay@chauffeur.com',
                icon: Icons.account_balance_wallet_outlined,
              ),

              // Venmo
              _buildInputField(
                label: 'Venmo Handle',
                controller: controller.venmoController,
                hint: 'e.g. @ChauffeurPay',
                icon: Icons.payment_outlined,
              ),

              // Cash App
              _buildInputField(
                label: 'Cash App Tag',
                controller: controller.cashAppController,
                hint: 'e.g. \$ChauffeurApp',
                icon: Icons.monetization_on_outlined,
              ),

              // Card Payment Switch Card
              Text(
                'Card Payments',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF27272A),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.credit_card_outlined,
                              color: const Color(0xFFD5C4AB),
                              size: 19.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Accept Card Payments",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Allow clients to pay via credit card",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF71717A),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: controller.cardPaymentAccepted.value,
                        activeThumbColor: const Color(0xFFD08700),
                        onChanged: (val) {
                          controller.cardPaymentAccepted.value = val;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(
              top: BorderSide(color: Color(0xFF1E1E1E), width: 1),
            ),
          ),
          child: SizedBox(
            height: 50.h,
            child: Obx(
              () => ElevatedButton.icon(
                onPressed: controller.isUpdating.value
                    ? null
                    : () => controller.savePaymentDetails(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD08700),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: controller.isUpdating.value
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline, color: Colors.black),
                label: Text(
                  controller.isUpdating.value
                      ? "Saving..."
                      : "Save Payment Details",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFF71717A),
                fontSize: 13.sp,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFFD5C4AB), size: 19.sp),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: Color(0xFFD08700), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
