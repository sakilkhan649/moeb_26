import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';

class ComplianceDocumentRepository {
  final ApiClient apiClient;

  ComplianceDocumentRepository({required this.apiClient});

  /// 1. GET /api/v1/documents/licenses
  /// Retrieves compliance license documents (DRIVING_LICENSE, HACK_LICENSE, LOCAL_PERMIT)
  Future<Response<dynamic>> getComplianceDocuments() async {
    return await apiClient.getData('${ApiConstants.documents}/licenses');
  }

  /// 2. PATCH /api/v1/documents/:id
  /// Updates document expiry date (JSON) and/or attached file (Multipart FormData)
  Future<Response<dynamic>> updateDocument({
    required String documentId,
    String? expiryDate,
    File? file,
  }) async {
    if (file != null) {
      final formData = FormData();
      if (expiryDate != null && expiryDate.trim().isNotEmpty) {
        final formattedDate = _formatDateToIso(expiryDate);
        formData.fields.add(MapEntry('expiryDate', formattedDate));
      }
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(file.path),
        ),
      );
      return await apiClient.patchData(
        '${ApiConstants.documents}/$documentId',
        formData,
      );
    } else {
      final String formattedDate =
          expiryDate != null ? _formatDateToIso(expiryDate) : '';
      return await apiClient.patchData(
        '${ApiConstants.documents}/$documentId',
        {
          if (formattedDate.isNotEmpty) "expiryDate": formattedDate,
        },
      );
    }
  }

  String _formatDateToIso(String dateStr) {
    final trimmed = dateStr.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      final parsed = DateTime.parse(trimmed);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      try {
        final parsed = DateFormat('dd MMMM yyyy').parse(trimmed);
        return DateFormat('yyyy-MM-dd').format(parsed);
      } catch (_) {
        return trimmed;
      }
    }
  }
}
