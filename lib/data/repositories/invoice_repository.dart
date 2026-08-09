import 'dart:io';
import 'package:dio/dio.dart';
import 'package:moeb_26/core/services/invoice_service.dart';
import 'package:moeb_26/data/models/invoice_model.dart';

class InvoiceRepository {
  final InvoiceService invoiceService;

  InvoiceRepository({required this.invoiceService});

  /// Create invoice via API
  Future<Response> createInvoice(InvoiceModel invoice) async {
    return await invoiceService.createInvoice(invoice);
  }

  /// Fetch list of invoices via API
  Future<Response> fetchInvoices() async {
    return await invoiceService.fetchInvoices();
  }

  /// Fetch invoice profile via API
  Future<Response> fetchInvoiceProfile() async {
    return await invoiceService.fetchInvoiceProfile();
  }

  /// Create or update invoice profile via API
  Future<Response> upsertInvoiceProfile(
    InvoiceProfileModel profile, {
    File? logoFile,
  }) async {
    return await invoiceService.upsertInvoiceProfile(profile, logoFile: logoFile);
  }

  /// Fetch single invoice by ID via API
  Future<Response> fetchInvoiceById(String id) async {
    return await invoiceService.fetchInvoiceById(id);
  }

  /// Update existing invoice by ID via API
  Future<Response> updateInvoice(String id, Map<String, dynamic> data) async {
    return await invoiceService.updateInvoice(id, data);
  }

  /// Delete invoice by ID via API
  Future<Response> deleteInvoice(String id) async {
    return await invoiceService.deleteInvoice(id);
  }
}




