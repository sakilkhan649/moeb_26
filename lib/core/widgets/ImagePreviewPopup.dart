import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImagePreviewPopup extends StatelessWidget {
  final File? file;
  final String? imageUrl;
  final String title;

  const ImagePreviewPopup({
    super.key,
    this.file,
    this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close Button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
          // Image Container
          Flexible(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: file != null
                      ? Image.file(
                          file!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : (imageUrl != null && imageUrl!.isNotEmpty)
                      ? (imageUrl!.startsWith('http')
                          ? Image.network(
                              imageUrl!,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFF1A107),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholder(),
                            )
                          : Image.asset(
                              imageUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholder(),
                            ))
                      : _buildPlaceholder(),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Title
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 80,
        ),
      ),
    );
  }
}
