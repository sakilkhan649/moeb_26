import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/core/services/api_client.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';
import 'package:moeb_26/core/widgets/ImagePreviewPopup.dart';
import 'package:moeb_26/data/models/compliance_document_model.dart';
import 'package:moeb_26/data/repositories/compliance_document_repository.dart';

/// Standalone controller for Compliance Documents
/// Dedicated solely to:
/// 1. Fetching compliance documents (GET /api/v1/documents/licenses)
/// 2. Updating compliance document expiry date & file (PATCH /api/v1/documents/:id)
class PersonalDocumentController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();

  late final ComplianceDocumentRepository _documentRepo;

  PersonalDocumentController() {
    _documentRepo = Get.isRegistered<ComplianceDocumentRepository>()
        ? Get.find<ComplianceDocumentRepository>()
        : Get.put(
            ComplianceDocumentRepository(apiClient: Get.find<ApiClient>()),
            permanent: true,
          );
  }

  var isLoading = false.obs;

  // Document IDs from server (for PATCH /api/v1/documents/:id)
  var drivingLicenseId = RxnString();
  var hackLicenseId = RxnString();
  var localPermitId = RxnString();

  // Document Statuses from server
  var drivingLicenseStatus = RxnString();
  var hackLicenseStatus = RxnString();
  var localPermitStatus = RxnString();

  // Individual Card Loading States
  var isUpdatingDrivingLicense = false.obs;
  var isUpdatingHackLicense = false.obs;
  var isUpdatingLocalPermit = false.obs;

  // RX variables for newly picked local files
  var drivingLicenseFile = Rx<File?>(null);
  var hackLicenseFile = Rx<File?>(null);
  var localPermitFile = Rx<File?>(null);

  // Existing image/file URLs from server
  var drivingLicenseUrl = RxnString();
  var hackLicenseUrl = RxnString();
  var localPermitUrl = RxnString();

  // Controllers for Expiry Dates
  final drivingLicenseExpireController = TextEditingController();
  final hackLicenseExpireController = TextEditingController();
  final localPermitExpireController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadExistingDocuments();
  }

  Future<void> fetchDocuments() => _loadExistingDocuments();

  /// 1. GET /api/v1/documents/licenses
  Future<void> _loadExistingDocuments() async {
    isLoading.value = true;
    try {
      final response = await _documentRepo.getComplianceDocuments();
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['data'] is List) {
        final List list = response.data['data'];
        for (var item in list) {
          if (item is! Map) continue;
          final doc = ComplianceDocumentModel.fromJson(
            Map<String, dynamic>.from(item),
          );
          final docType = doc.documentType.toUpperCase();

          if (docType == 'DRIVING_LICENSE') {
            drivingLicenseId.value = doc.id;
            drivingLicenseStatus.value = doc.status;
            drivingLicenseUrl.value = doc.fullFileUrl;
            if (doc.formattedExpiryDate.isNotEmpty) {
              drivingLicenseExpireController.text = doc.formattedExpiryDate;
            }
          } else if (docType == 'HACK_LICENSE') {
            hackLicenseId.value = doc.id;
            hackLicenseStatus.value = doc.status;
            hackLicenseUrl.value = doc.fullFileUrl;
            if (doc.formattedExpiryDate.isNotEmpty) {
              hackLicenseExpireController.text = doc.formattedExpiryDate;
            }
          } else if (docType == 'LOCAL_PERMIT') {
            localPermitId.value = doc.id;
            localPermitStatus.value = doc.status;
            localPermitUrl.value = doc.fullFileUrl;
            if (doc.formattedExpiryDate.isNotEmpty) {
              localPermitExpireController.text = doc.formattedExpiryDate;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching compliance documents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. PATCH /api/v1/documents/:id
  Future<void> updateSingleDocument(String documentType) async {
    final bool isDL = documentType == 'DRIVING_LICENSE';
    final bool isHL = documentType == 'HACK_LICENSE';

    final String title = isDL
        ? "Driving License"
        : isHL
            ? "Hack License"
            : "Local Permit";

    final RxnString docIdRx = isDL
        ? drivingLicenseId
        : isHL
            ? hackLicenseId
            : localPermitId;

    final RxnString statusRx = isDL
        ? drivingLicenseStatus
        : isHL
            ? hackLicenseStatus
            : localPermitStatus;

    final RxnString urlRx = isDL
        ? drivingLicenseUrl
        : isHL
            ? hackLicenseUrl
            : localPermitUrl;

    final Rx<File?> fileRx = isDL
        ? drivingLicenseFile
        : isHL
            ? hackLicenseFile
            : localPermitFile;

    final TextEditingController expireController = isDL
        ? drivingLicenseExpireController
        : isHL
            ? hackLicenseExpireController
            : localPermitExpireController;

    final RxBool isUpdatingRx = isDL
        ? isUpdatingDrivingLicense
        : isHL
            ? isUpdatingHackLicense
            : isUpdatingLocalPermit;

    final docId = docIdRx.value;
    final file = fileRx.value;
    final expiryText = expireController.text.trim();

    if (file == null && expiryText.isEmpty) {
      Helpers.showCustomSnackBar(
        'Please select an expiration date or attach a file to update $title.',
        isError: true,
      );
      return;
    }

    if (docId == null || docId.isEmpty) {
      Helpers.showCustomSnackBar(
        'Document ID not found for $title.',
        isError: true,
      );
      return;
    }

    try {
      isUpdatingRx.value = true;

      final response = await _documentRepo.updateDocument(
        documentId: docId,
        expiryDate: expiryText.isNotEmpty ? expiryText : null,
        file: file,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fileRx.value = null; // Clear local picked file
        if (response.data?['data'] is Map) {
          final updatedDoc = ComplianceDocumentModel.fromJson(
            Map<String, dynamic>.from(response.data['data']),
          );
          statusRx.value = updatedDoc.status;
          if (updatedDoc.fullFileUrl != null &&
              updatedDoc.fullFileUrl!.isNotEmpty) {
            urlRx.value = updatedDoc.fullFileUrl;
          }
          if (updatedDoc.formattedExpiryDate.isNotEmpty) {
            expireController.text = updatedDoc.formattedExpiryDate;
          }
        }
        Helpers.showCustomSnackBar(
          '$title updated successfully.',
          isError: false,
        );
      } else {
        final msg = response.data?['message'] ?? 'Failed to update $title.';
        Helpers.showCustomSnackBar(msg, isError: true);
      }
    } catch (e) {
      debugPrint("Error updating $title: $e");
      Helpers.showCustomSnackBar(
        'Something went wrong updating $title.',
        isError: true,
      );
    } finally {
      isUpdatingRx.value = false;
    }
  }

  /// Date picker dialog
  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF14F195),
            onPrimary: Colors.black,
            surface: Color(0xFF1E2939),
            onSurface: Colors.white,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: const Color(0xFF1E2939),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  bool _isPicking = false;

  Future<void> pickFromCamera(Rx<File?> target) async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        final file = File(image.path);
        final compressed = await Helpers.compressImage(file);
        final fileSize = await compressed.length();
        if (fileSize > 1024 * 1024) {
          Helpers.showCustomSnackBar(
            'Maximum file size allowed is 1MB',
            isError: true,
          );
          return;
        }
        target.value = compressed;
      }
    } catch (e) {
      Helpers.error('Error picking from camera: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> pickFromGallery(BuildContext context, Rx<File?> target) async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final File? file = await MediaPickerHelper.pickSingleImage(context);
      if (file != null) {
        final compressed = await Helpers.compressImage(file);
        final fileSize = await compressed.length();
        if (fileSize > 1024 * 1024) {
          Helpers.showCustomSnackBar(
            'Maximum file size allowed is 1MB',
            isError: true,
          );
          return;
        }
        target.value = compressed;
      }
    } catch (e) {
      Helpers.error('Error picking from gallery: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> pickFromFile(BuildContext context, Rx<File?> target) async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final File? file = await MediaPickerHelper.showImageOrPdfPicker(context);
      if (file != null) {
        final path = file.path.toLowerCase();
        final isImage = !path.endsWith('.pdf');

        if (isImage) {
          final compressed = await Helpers.compressImage(file);
          final fileSize = await compressed.length();
          if (fileSize > 1024 * 1024) {
            Helpers.showCustomSnackBar(
              'Maximum file size allowed is 1MB',
              isError: true,
            );
            return;
          }
          target.value = compressed;
        } else {
          final fileSize = await file.length();
          if (fileSize > 1024 * 1024) {
            Helpers.showCustomSnackBar(
              'Maximum file size allowed is 1MB',
              isError: true,
            );
            return;
          }
          target.value = file;
        }
      }
    } catch (e) {
      Helpers.error('Error picking from file: $e');
    } finally {
      _isPicking = false;
    }
  }

  String getFileName(Rx<File?> file) {
    if (file.value == null) return '';
    final name = file.value!.path.split('/').last.split('\\').last;
    if (name.length > 20) {
      final extIndex = name.lastIndexOf('.');
      final ext = extIndex != -1 ? name.substring(extIndex) : '';
      final base = extIndex != -1 ? name.substring(0, extIndex) : name;
      if (base.length > 12) {
        return '${base.substring(0, 7)}...${base.substring(base.length - 4)}$ext';
      }
    }
    return name;
  }

  /// Shows preview dialog for server URL or local picked file
  void previewImage(
    BuildContext context,
    Rx<File?> fileRx,
    RxnString urlRx, {
    String title = "Document Preview",
  }) {
    final localFile = fileRx.value;
    final serverUrl = urlRx.value;

    if (localFile == null && (serverUrl == null || serverUrl.isEmpty)) {
      Helpers.showCustomSnackBar(
        'No image available to preview.',
        isError: true,
      );
      return;
    }

    Get.dialog(
      ImagePreviewPopup(file: localFile, imageUrl: serverUrl, title: title),
    );
  }

  @override
  void onClose() {
    drivingLicenseExpireController.dispose();
    hackLicenseExpireController.dispose();
    localPermitExpireController.dispose();
    super.onClose();
  }
}
