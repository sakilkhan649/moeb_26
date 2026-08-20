import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/config/themes/app_theme.dart';
import 'package:moeb_26/core/widgets/custom_sub_appbar.dart';
import 'package:moeb_26/core/widgets/CustomButton.dart';
import 'package:moeb_26/core/widgets/CustomTextGary.dart';
import 'package:moeb_26/modules/my_schedule/controllers/my_schedule_controller.dart';
import 'package:moeb_26/modules/my_schedule/models/my_schedule_job_model.dart';
import 'package:moeb_26/modules/preferred_drivers/controllers/preferred_drivers_controller.dart';
import 'package:moeb_26/modules/jobs_posts/controllers/job_post_controller.dart';
import 'package:moeb_26/modules/jobs_posts/views/job_post_sheet_tabbar_view.dart';

class AddScheduleJobSheet extends StatefulWidget {
  final MyScheduleJobModel? existingJob;

  const AddScheduleJobSheet({super.key, this.existingJob});

  @override
  State<AddScheduleJobSheet> createState() => _AddScheduleJobSheetState();
}

class _AddScheduleJobSheetState extends State<AddScheduleJobSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _pickupController;
  late TextEditingController _dropoffController;
  late TextEditingController _fareController;
  late TextEditingController _notesController;
  late TextEditingController _paymentInfoController;

  late DateTime _selectedDateTime;
  late String _selectedVehicleType;
  late bool _isPaid;
  late String _selectedPaymentMethod;
  String? _selectedChauffeurId;
  String? _selectedChauffeurName;

  final List<String> _vehicles = [
    'SEDAN',
    'SUV',
    'SPRINTER',
    'LIMO STRETCH',
    'SEDAN/SUV',
  ];

  final List<String> _paymentMethods = [
    'Cash / Direct',
    'Credit Card',
    'Zelle',
    'Venmo',
    'Corporate Invoice',
  ];

  @override
  void initState() {
    super.initState();
    final job = widget.existingJob;
    final controller = Get.find<MyScheduleController>();

    _nameController = TextEditingController(text: job?.clientName ?? '');
    _phoneController = TextEditingController(text: job?.clientPhone ?? '');
    _pickupController = TextEditingController(text: job?.pickupLocation ?? '');
    _dropoffController = TextEditingController(text: job?.dropoffLocation ?? '');
    _fareController = TextEditingController(text: job?.fare ?? '');
    _notesController = TextEditingController(text: job?.notes ?? '');
    _paymentInfoController = TextEditingController(text: job?.paymentInfo ?? '');

    _selectedDateTime = job?.pickupDateTime ?? controller.selectedDate.value;
    _isPaid = job?.isPaid ?? false;
    _selectedPaymentMethod = job?.paymentMethod ?? _paymentMethods.first;
    _selectedChauffeurId = job?.assignedChauffeurId;
    _selectedChauffeurName = job?.assignedChauffeurName;

    final existingType = job?.vehicleType.toUpperCase().trim() ?? 'SEDAN';
    if (_vehicles.contains(existingType)) {
      _selectedVehicleType = existingType;
    } else if (existingType == 'EXECUTIVE SEDAN') {
      _selectedVehicleType = 'SEDAN';
    } else if (existingType == 'LUXURY SUV') {
      _selectedVehicleType = 'SUV';
    } else if (existingType == 'CHAUFFEUR VAN') {
      _selectedVehicleType = 'SPRINTER';
    } else {
      _selectedVehicleType = 'SEDAN';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pickupController.dispose();
    _dropoffController.dispose();
    _fareController.dispose();
    _notesController.dispose();
    _paymentInfoController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E22),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    if (!mounted) return;
    final pickedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E22),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final controller = Get.find<MyScheduleController>();
      final PostJobController postJobController = Get.isRegistered<PostJobController>()
          ? Get.find<PostJobController>()
          : Get.put(PostJobController());
      final isEdit = widget.existingJob != null;

      final chauffeurText = postJobController.chauffeurSelectionText;
      final assignedName = (chauffeurText != 'Select Chauffeur / Service Area')
          ? chauffeurText
          : widget.existingJob?.assignedChauffeurName;

      final job = MyScheduleJobModel(
        id: isEdit ? widget.existingJob!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        clientName: _nameController.text.trim(),
        clientPhone: _phoneController.text.trim(),
        pickupDateTime: _selectedDateTime,
        pickupLocation: _pickupController.text.trim(),
        dropoffLocation: _dropoffController.text.trim(),
        vehicleType: _selectedVehicleType,
        fare: _fareController.text.trim(),
        notes: _notesController.text.trim(),
        isDispatchedToNetwork: widget.existingJob?.isDispatchedToNetwork ?? false,
        status: widget.existingJob?.status ?? "Scheduled",
        isPaid: _isPaid,
        assignedChauffeurId: _selectedChauffeurId,
        assignedChauffeurName: assignedName,
        paymentMethod: _selectedPaymentMethod,
        paymentInfo: _paymentInfoController.text.trim(),
      );

      Navigator.of(context).pop();

      if (isEdit) {
        controller.updateJob(job);
      } else {
        controller.addJob(job);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingJob != null;
    final PostJobController postJobController = Get.isRegistered<PostJobController>()
        ? Get.find<PostJobController>()
        : Get.put(PostJobController());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      appBar: CustomSubAppBar(
        title: isEdit ? "Edit Direct Booking" : "Add Direct Booking",
        onBackPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextgray(
                text: "Logged as a private direct booking for your personal schedule",
                fontSize: 12.sp,
              ),
              SizedBox(height: 16.h),

              // Client Name
              _buildTextField(
                controller: _nameController,
                label: "Client Name *",
                hint: "e.g. John Smith",
                validator: (v) => v == null || v.trim().isEmpty ? "Client name required" : null,
              ),
              SizedBox(height: 14.h),

              // Client Phone
              _buildTextField(
                controller: _phoneController,
                label: "Client Phone Number *",
                hint: "e.g. +1 (555) 019-2834",
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty ? "Phone number required" : null,
              ),
              SizedBox(height: 14.h),

              // Date & Time Picker
              _buildLabel("Pickup Date & Time *"),
              SizedBox(height: 6.h),
              InkWell(
                onTap: () => _pickDateTime(context),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E22),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF2C2C34)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('EEE, MMM d, yyyy  •  hh:mm a').format(_selectedDateTime),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.edit_calendar_outlined, size: 18.sp, color: AppColors.gray100),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // Pickup Location
              _buildTextField(
                controller: _pickupController,
                label: "Pickup Location *",
                hint: "e.g. JFK Terminal 4 / Address",
                validator: (v) => v == null || v.trim().isEmpty ? "Pickup location required" : null,
              ),
              SizedBox(height: 14.h),

              // Dropoff Location
              _buildTextField(
                controller: _dropoffController,
                label: "Drop-off Location *",
                hint: "e.g. Hotel / Destination",
                validator: (v) => v == null || v.trim().isEmpty ? "Dropoff location required" : null,
              ),
              SizedBox(height: 14.h),

              // Vehicle Type Chip Pills Selector
              FormField<String>(
                initialValue: _selectedVehicleType,
                validator: (val) {
                  if (_selectedVehicleType.isEmpty) {
                    return "Please select a vehicle type";
                  }
                  return null;
                },
                builder: (FormFieldState<String> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.vechile_car_icon,
                            height: 18.sp,
                            width: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Vehicle Type Required *',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: _vehicles.map((vehicle) {
                          final isSelected = _selectedVehicleType == vehicle;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedVehicleType = vehicle;
                              });
                              state.didChange(vehicle);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF364153)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : const Color(0xFF364153),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Text(
                                vehicle,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : Colors.white70,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            state.errorText!,
                            style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: 14.h),

              // Fare
              _buildTextField(
                controller: _fareController,
                label: "Price / Fare (Optional)",
                hint: "e.g. \$150.00",
              ),
              SizedBox(height: 14.h),

              // Chauffeur Selection (Using exact same component from Job Post Screen)
              JobPostSheetTabBarView.buildChauffeurSelection(
                context,
                postJobController,
              ),
              SizedBox(height: 14.h),

              // Payment Status (Paid / Not Paid)
              _buildLabel("Payment Status *"),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPaid = false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: !_isPaid ? const Color(0xFF3D1F1F) : const Color(0xFF1E1E22),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: !_isPaid ? Colors.redAccent : const Color(0xFF2C2C34),
                            width: !_isPaid ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 16.sp,
                              color: !_isPaid ? Colors.redAccent : Colors.white54,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Not Paid",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: !_isPaid ? FontWeight.bold : FontWeight.w500,
                                color: !_isPaid ? Colors.redAccent : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPaid = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _isPaid ? const Color(0xFF1F3D24) : const Color(0xFF1E1E22),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _isPaid ? Colors.greenAccent : const Color(0xFF2C2C34),
                            width: _isPaid ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16.sp,
                              color: _isPaid ? Colors.greenAccent : Colors.white54,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Paid",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: _isPaid ? FontWeight.bold : FontWeight.w500,
                                color: _isPaid ? Colors.greenAccent : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              // Payment Method
              _buildLabel("Payment Method"),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E22),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF2C2C34)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPaymentMethod,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E1E22),
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 20.sp),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedPaymentMethod = val);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // Client Payment Info
              _buildTextField(
                controller: _paymentInfoController,
                label: "Client Payment Details / Notes",
                hint: "e.g. Receipt #, Zelle phone, Cash on delivery notes",
              ),
              SizedBox(height: 14.h),

              // Notes
              _buildTextField(
                controller: _notesController,
                label: "Notes / Special Requests (Optional)",
                hint: "e.g. Flight details, luggage specs",
                maxLines: 2,
              ),
              SizedBox(height: 24.h),

              CustomButton(
                text: isEdit ? "Update Booking" : "Save Direct Booking",
                onPressed: _submit,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: Colors.white38,
              fontSize: 13.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF1E1E22),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF2C2C34)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF2C2C34)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            // Remove red error outline borders while keeping error text below
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF2C2C34)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            errorStyle: GoogleFonts.inter(
              color: Colors.redAccent,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
