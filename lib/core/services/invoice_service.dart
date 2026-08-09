import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';
import 'package:moeb_26/data/models/invoice_model.dart';

class InvoiceService extends GetxService {
  late ApiClient _apiClient;

  @override
  void onInit() {
    super.onInit();
    _apiClient = Get.find<ApiClient>();
  }

  Future<InvoiceService> init() async {
    return this;
  }

  /// Create a new invoice
  Future<Response> createInvoice(InvoiceModel invoice) async {
    final body = invoice.toJson();
    return await _apiClient.postData(
      ApiConstants.invoices,
      body,
    );
  }

  /// Fetch all invoices for the authenticated user
  Future<Response> fetchInvoices() async {
    return await _apiClient.getData(
      ApiConstants.invoices,
    );
  }

  /// Fetch invoice profile for the authenticated user
  Future<Response> fetchInvoiceProfile() async {
    return await _apiClient.getData(
      ApiConstants.invoiceProfile,
    );
  }

  /// Create or update invoice profile (supports optional logo file upload)
  Future<Response> upsertInvoiceProfile(
    InvoiceProfileModel profile, {
    File? logoFile,
  }) async {
    final body = profile.toJson();
    if (logoFile != null && logoFile.existsSync()) {
      return await _apiClient.putMultipartData(
        ApiConstants.invoiceProfile,
        body,
        multipartBody: [MultipartBody('logo', logoFile)],
      );
    } else {
      return await _apiClient.putData(
        ApiConstants.invoiceProfile,
        body,
      );
    }
  }
  /// Fetch single invoice by ID
  Future<Response> fetchInvoiceById(String id) async {
    return await _apiClient.getData('${ApiConstants.invoices}/$id');
  }

  /// Update existing invoice by ID
  Future<Response> updateInvoice(String id, Map<String, dynamic> data) async {
    return await _apiClient.patchData('${ApiConstants.invoices}/$id', data);
  }

  /// Delete existing invoice by ID
  Future<Response> deleteInvoice(String id) async {
    return await _apiClient.deleteData('${ApiConstants.invoices}/$id');
  }

  /// Fetch all saved clients via API
  Future<Response> fetchClients() async {
    return await _apiClient.getData(ApiConstants.invoiceClient);
  }

  /// Create client via API
  Future<Response> createClient(Map<String, dynamic> data) async {
    return await _apiClient.postData(ApiConstants.invoiceClient, data);
  }

  /// Update client by ID via API
  Future<Response> updateClient(String id, Map<String, dynamic> data) async {
    return await _apiClient.patchData('${ApiConstants.invoiceClient}/$id', data);
  }

  /// Delete client by ID via API
  Future<Response> deleteClient(String id) async {
    return await _apiClient.deleteData('${ApiConstants.invoiceClient}/$id');
  }
}





