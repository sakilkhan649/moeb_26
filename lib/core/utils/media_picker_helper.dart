import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MediaPickerHelper {
  /// Picks a single image from the gallery and returns a File.
  static Future<File?> pickSingleImage(BuildContext context) async {
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
  static Future<List<File>?> pickMultiImages(BuildContext context, {int maxImages = 9}) async {
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

  /// Shows a premium sheet to choose between picking an image from WeChat Picker or a PDF document.
  static Future<File?> showImageOrPdfPicker(BuildContext context) async {
    final File? selectedFile = await Get.bottomSheet<File?>(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2632),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Upload Source",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withAlpha(51), // 20% opacity (0.2 * 255 = 51)
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.image_outlined, color: Color(0xFF6C63FF)),
                ),
                title: Text(
                  "Image Gallery",
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Choose a photo from your library",
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp),
                ),
                onTap: () async {
                  final File? file = await pickSingleImage(context);
                  Get.back(result: file);
                },
              ),
              const Divider(color: Colors.white12),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(51), // 20% opacity
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.green),
                ),
                title: Text(
                  "PDF Document",
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Choose a PDF file from storage",
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp),
                ),
                onTap: () async {
                  try {
                    final FilePickerResult? result = await FilePicker.platform.pickFiles(
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
      barrierColor: Colors.black54,
    );

    return selectedFile;
  }
}
