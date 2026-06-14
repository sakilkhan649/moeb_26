import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MediaPickerHelper {
  /// Check photo library permissions and redirect to settings if denied
  static Future<bool> checkPermission(BuildContext context) async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps == PermissionState.denied || ps == PermissionState.restricted) {
        await _showPermissionSettingsDialog(context);
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error checking permission: $e");
      return false;
    }
  }

  /// Show settings dialog for permissions
  static Future<void> _showPermissionSettingsDialog(
    BuildContext context,
  ) async {
    await Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E2632),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Permission Required",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        content: Text(
          "We need access to your photo library to let you select and upload images. Please enable it in Settings.",
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              PhotoManager.openSetting();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Open Settings",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierColor: Colors.black54,
    );
  }

  /// Picks a single image from the gallery and returns a File.
  static Future<File?> pickSingleImage(BuildContext context) async {
    final hasPermission = await checkPermission(context);
    if (!hasPermission) return null;

    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
          themeColor: Color(0xFF6C63FF),
          textDelegate: EnglishAssetPickerTextDelegate(),
        ),
      );

      if (result != null && result.isNotEmpty) {
        return (await result.first.file) ?? (await result.first.originFile);
      }
    } catch (e) {
      debugPrint("Error picking single image: $e");
    }
    return null;
  }

  /// Picks multiple images from the gallery and returns a list of Files.
  static Future<List<File>?> pickMultiImages(
    BuildContext context, {
    int maxImages = 9,
  }) async {
    final hasPermission = await checkPermission(context);
    if (!hasPermission) return null;

    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxImages,
          requestType: RequestType.image,
          themeColor: const Color(0xFF6C63FF),
          textDelegate: const EnglishAssetPickerTextDelegate(),
        ),
      );

      if (result != null && result.isNotEmpty) {
        final List<File> files = [];
        for (final entity in result) {
          final file = (await entity.file) ?? (await entity.originFile);
          if (file != null) {
            files.add(file);
          }
        }
        return files;
      }
    } catch (e) {
      debugPrint("Error picking multiple images: $e");
    }
    return null;
  }

  /// Shows a premium dialog popup to choose between picking an image from WeChat Picker or a PDF document.
  static Future<File?> showImageOrPdfPicker(BuildContext context) async {
    final File? selectedFile = await Get.dialog<File?>(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color:
                Colors.black, // Black background matching application dialogs
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFF374151),
              width: 1.w,
            ), // Light grey border
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Upload Source",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(result: null),
                    child: Icon(Icons.close, color: Colors.grey, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(51), // 20% opacity
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.image_outlined, color: Colors.grey),
                ),
                title: Text(
                  "Image Gallery",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                subtitle: Text(
                  "Choose a photo from your library",
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 11.sp),
                ),
                onTap: () async {
                  final File? file = await pickSingleImage(context);
                  Get.back(result: file);
                },
              ),
              const Divider(color: Colors.white12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(51), // 20% opacity
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.grey,
                  ),
                ),
                title: Text(
                  "PDF Document",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                subtitle: Text(
                  "Choose a PDF file from storage",
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 11.sp),
                ),
                onTap: () async {
                  try {
                    final FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                    if (result != null && result.files.single.path != null) {
                      Get.back(result: File(result.files.single.path!));
                    } else {
                      Get.back(result: null);
                    }
                  } catch (e) {
                    debugPrint("Error picking PDF: $e");
                    Get.back(result: null);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.74),
    );

    return selectedFile;
  }
}
