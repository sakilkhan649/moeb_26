import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import '../controllers/invoice_controller.dart';

class SavedClientsView extends GetView<InvoiceController> {
  const SavedClientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
            ),
          ),
          child: AppBar(
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
              'Saved Clients',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.savedClients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  color: const Color(0xFF364153),
                  size: 64.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No Saved Clients',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFD5C4AB),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Clients are saved automatically when creating invoices.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF52525B),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          itemCount: controller.savedClients.length,
          separatorBuilder: (context, index) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final client = controller.savedClients[index];
            return _buildClientCard(context, client);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD08700),
        foregroundColor: Colors.black,
        onPressed: () => _showAddOrEditClientBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildClientCard(BuildContext context, SavedClient client) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: const Color(0xFFFEDB9B),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (client.businessName.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        client.businessName,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFEDB9B),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  AppIcons.edit_icon,
                  width: 20.sp,
                  height: 20.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFD5C4AB),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () =>
                    _showAddOrEditClientBottomSheet(context, client: client),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  AppIcons.delete_icon,
                  width: 20.sp,
                  height: 20.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFEF4444),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  controller.deleteSavedClient(client.id);
                  Get.snackbar(
                    'Deleted',
                    'Client removed from saved list',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: Color(0xFF1E1E1E), height: 1),
          SizedBox(height: 12.h),
          if (client.email.isNotEmpty)
            _buildInfoRow(Icons.email_outlined, client.email),
          if (client.phone.isNotEmpty) ...[
            SizedBox(height: 6.h),
            _buildInfoRow(Icons.phone_outlined, client.phone),
          ],
          if (client.streetAddress.isNotEmpty || client.city.isNotEmpty) ...[
            SizedBox(height: 6.h),
            _buildInfoRow(
              Icons.location_on_outlined,
              [
                if (client.streetAddress.isNotEmpty) client.streetAddress,
                if (client.city.isNotEmpty) client.city,
                if (client.state.isNotEmpty) client.state,
                if (client.country.isNotEmpty) client.country,
              ].join(', '),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF71717A), size: 14.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFFA1A1AA),
              fontSize: 12.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showAddOrEditClientBottomSheet(
    BuildContext context, {
    SavedClient? client,
  }) {
    final isEditing = client != null;
    final nameController = TextEditingController(text: client?.name ?? '');
    final businessController = TextEditingController(
      text: client?.businessName ?? '',
    );
    final emailController = TextEditingController(text: client?.email ?? '');
    final phoneController = TextEditingController(text: client?.phone ?? '');
    final streetController = TextEditingController(
      text: client?.streetAddress ?? '',
    );
    final cityController = TextEditingController(text: client?.city ?? '');
    final stateController = TextEditingController(text: client?.state ?? '');
    final zipController = TextEditingController(text: client?.zip ?? '');
    String selectedCountry = client?.country ?? 'United States';

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: 580.h),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: const Color(0xFF2C2C2C), width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Client' : 'Add New Client',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModalFieldLabel('Client Name*'),
                    _buildModalInput(nameController, 'e.g. Johnathan Smith'),
                    SizedBox(height: 12.h),

                    _buildModalFieldLabel('Business Name'),
                    _buildModalInput(
                      businessController,
                      'e.g. Smith & Associates',
                    ),
                    SizedBox(height: 12.h),

                    _buildModalFieldLabel('Email Address*'),
                    _buildModalInput(
                      emailController,
                      'client@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12.h),

                    _buildModalFieldLabel('Phone Number'),
                    _buildModalInput(
                      phoneController,
                      'e.g. 555-000-0000',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12.h),

                    _buildModalFieldLabel('Street Address'),
                    _buildModalInput(
                      streetController,
                      'e.g. 123 Luxury Avenue',
                    ),
                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildModalFieldLabel('City'),
                              _buildModalInput(
                                cityController,
                                'e.g. Beverly Hills',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildModalFieldLabel('State'),
                              _buildModalInput(stateController, 'e.g. CA'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD08700),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    Get.snackbar(
                      'Required',
                      'Client name is required',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final newClient = SavedClient(
                    id: isEditing
                        ? client.id
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    businessName: businessController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                    streetAddress: streetController.text.trim(),
                    city: cityController.text.trim(),
                    state: stateController.text.trim(),
                    zip: zipController.text.trim(),
                    country: selectedCountry,
                  );

                  controller.addOrUpdateSavedClient(newClient);
                  Get.back();
                  Get.snackbar(
                    'Success',
                    isEditing
                        ? 'Client updated successfully'
                        : 'New client added successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFD08700),
                    colorText: Colors.black,
                  );
                },
                child: Text(
                  isEditing ? 'Save Changes' : 'Add Client',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildModalFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFFD5C4AB),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildModalInput(
    TextEditingController ctrl,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF52525B),
          fontSize: 13.sp,
        ),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF2C2C2C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFD08700)),
        ),
      ),
    );
  }
}
