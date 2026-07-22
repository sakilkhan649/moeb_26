import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/data/models/market_place_model.dart';
import 'package:moeb_26/core/widgets/ContactSellerPopup.dart';
import 'package:moeb_26/core/widgets/ImagePreviewPopup.dart';
import 'package:moeb_26/core/widgets/SellItemBottomSheet.dart';
import 'package:moeb_26/modules/market_place/controllers/market_place_controller.dart';
import 'package:moeb_26/modules/my_items/controllers/my_items_controller.dart';

class MarketplaceItemDetailView extends StatefulWidget {
  final ItemData item;
  final bool isOwnItem;

  const MarketplaceItemDetailView({
    super.key,
    required this.item,
    this.isOwnItem = false,
  });

  @override
  State<MarketplaceItemDetailView> createState() =>
      _MarketplaceItemDetailViewState();
}

class _MarketplaceItemDetailViewState extends State<MarketplaceItemDetailView> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.item.photos ?? [];
    final imageCount = photos.length;
    final String title = widget.item.title ?? "No Title";

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
              'Item Details',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Gallery / Carousel
                  SizedBox(
                    height: 320.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        if (imageCount == 0)
                          _buildNoImagePlaceholder()
                        else
                          PageView.builder(
                            controller: _pageController,
                            itemCount: imageCount,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final photoUrl = photos[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    ImagePreviewPopup(
                                      imageUrl: photoUrl,
                                      title: title,
                                    ),
                                  );
                                },
                                child: Image.network(
                                  photoUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildNoImagePlaceholder(),
                                ),
                              );
                            },
                          ),

                        // Image Index Badge (e.g. 1 / 4)
                        if (imageCount > 1)
                          Positioned(
                            bottom: 16.h,
                            right: 16.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: const Color(0xFF2C2C2C),
                                ),
                              ),
                              child: Text(
                                '${_currentImageIndex + 1} / $imageCount',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        // Dot indicators
                        if (imageCount > 1)
                          Positioned(
                            bottom: 16.h,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                imageCount,
                                (index) => Container(
                                  width: 8.w,
                                  height: 8.w,
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? const Color(0xFFFF9800)
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Item Details Block
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price tag
                        Text(
                          "\$${widget.item.price ?? 0}",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF9800),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Title
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey.shade500,
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              widget.item.location ?? "No location",
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade400,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),
                        const Divider(color: Color(0xFF1E1E1E), height: 1),
                        SizedBox(height: 16.h),

                        // Specs Row (Condition / Status)
                        Row(
                          children: [
                            if (widget.item.condition != null && widget.item.condition!.isNotEmpty) ...[
                              _buildBadge(
                                label: "Condition: ${widget.item.condition}",
                                backgroundColor: const Color(0xFF1F1C1C),
                                textColor: const Color(0xFFD5C4AB),
                              ),
                              SizedBox(width: 10.w),
                            ],
                            if (widget.item.status != null)
                              _buildBadge(
                                label: widget.item.status!.toUpperCase(),
                                backgroundColor: widget.item.status == 'Active'
                                    ? Colors.green.withValues(alpha: 0.15)
                                    : Colors.orange.withValues(alpha: 0.15),
                                textColor: widget.item.status == 'Active'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                          ],
                        ),

                        SizedBox(height: 16.h),
                        const Divider(color: Color(0xFF1E1E1E), height: 1),
                        SizedBox(height: 16.h),

                        // Description Section
                        Text(
                          "Description",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.item.description ?? "No description provided.",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                            height: 1.5,
                          ),
                        ),

                        if (!widget.isOwnItem) ...[
                          SizedBox(height: 24.h),
                          const Divider(color: Color(0xFF1E1E1E), height: 1),
                          SizedBox(height: 20.h),

                          // Seller Profile Section
                          Text(
                            "Seller Information",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: const Color(0xFF242424),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundImage:
                                      (widget.item.createdBy?.profilePicture !=
                                              null &&
                                          widget
                                              .item
                                              .createdBy!
                                              .profilePicture!
                                              .isNotEmpty)
                                      ? NetworkImage(
                                          widget
                                              .item
                                              .createdBy!
                                              .profilePicture!,
                                        )
                                      : null,
                                  backgroundColor: const Color(0xFF27272A),
                                  child:
                                      (widget.item.createdBy?.profilePicture ==
                                              null ||
                                          widget
                                              .item
                                              .createdBy!
                                              .profilePicture!
                                              .isEmpty)
                                      ? Text(
                                          widget.item.createdBy?.name
                                                  ?.substring(0, 1)
                                                  .toUpperCase() ??
                                              "S",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.item.createdBy?.name ??
                                            "Unknown Seller",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (widget.item.createdBy?.email !=
                                          null) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          widget.item.createdBy!.email!,
                                          style: GoogleFonts.inter(
                                            color: Colors.grey.shade500,
                                            fontSize: 13.sp,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Fixed Action Panel
          Container(
            padding: EdgeInsets.fromLTRB(
              20.w,
              16.h,
              20.w,
              MediaQuery.of(context).padding.bottom + 16.h,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF0C0C0C),
              border: Border(
                top: BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
              ),
            ),
            child: widget.isOwnItem
                ? Row(
                    children: [
                      // Edit Button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final MarketplaceController mpc;
                            if (Get.isRegistered<MarketplaceController>()) {
                              mpc = Get.find<MarketplaceController>();
                            } else {
                              mpc = Get.put(MarketplaceController());
                            }
                            mpc.prefillForEdit(
                              widget.item.title ?? '',
                              widget.item.price?.toString() ?? '0',
                              widget.item.location ?? '',
                              widget.item.condition ?? '',
                              widget.item.description ?? '',
                              widget.item.photos ?? [],
                            );
                            Get.bottomSheet(
                              SellItemBottomSheet(editItemId: widget.item.id),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFF9800,
                            ), // Match brand orange
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Edit Item",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Delete Button
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => _showDeleteDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1E1E),
                            foregroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              side: const BorderSide(color: Color(0xFF2E2E2E)),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 18.sp,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Delete",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.dialog(ContactSellerPopup(item: widget.item));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFF9800,
                            ), // Match brand orange
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppIcons.contact_icon,
                                height: 18.sp,
                                width: 18.sp,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Contact Seller",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          "Delete Item",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this item? This action cannot be undone.",
          style: GoogleFonts.inter(color: const Color(0xff949494)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              if (Get.isRegistered<MyItemsController>()) {
                final MyItemsController controller =
                    Get.find<MyItemsController>();
                controller.deleteItem(widget.item.id ?? '');
              }
              Get.back(); // close dialog
              Get.back(); // pop detailed view page
            },
            child: Text(
              "Delete",
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNoImagePlaceholder() {
    return Container(
      color: Colors.grey[900],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 40.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            "No Image Available",
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
