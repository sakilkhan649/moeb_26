class BillingAddressModel {
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  BillingAddressModel({
    this.streetAddress,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  factory BillingAddressModel.fromJson(Map<String, dynamic> json) {
    return BillingAddressModel(
      streetAddress: json['streetAddress'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streetAddress': streetAddress ?? '',
      'city': city ?? '',
      'state': state ?? '',
      'zipCode': zipCode ?? '',
      'country': country ?? '',
    };
  }
}

class SenderDetailsModel {
  final String? businessName;
  final String? email;
  final String? phoneNumber;
  final String? website;
  final String? address;
  final String? logo;

  SenderDetailsModel({
    this.businessName,
    this.email,
    this.phoneNumber,
    this.website,
    this.address,
    this.logo,
  });

  factory SenderDetailsModel.fromJson(Map<String, dynamic> json) {
    return SenderDetailsModel(
      businessName: json['businessName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      logo: json['logo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'email': email,
      'phoneNumber': phoneNumber,
      'website': website,
      'address': address,
      'logo': logo,
    };
  }
}

class InvoiceModel {
  final String? id;
  final String? invoiceNumber;
  final double? invoiceAmount;
  final DateTime? issueDate;
  final String? dueDateType;
  final DateTime? customDueDate;
  final String? currency;
  final String? clientName;
  final String? businessName;
  final String? emailAddress;
  final String? phoneNumber;
  final BillingAddressModel? billingAddress;
  final String? description;
  final String? messageToClient;
  final String? status;
  final String? user;
  final SenderDetailsModel? senderDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvoiceModel({
    this.id,
    this.invoiceNumber,
    this.invoiceAmount,
    this.issueDate,
    this.dueDateType,
    this.customDueDate,
    this.currency,
    this.clientName,
    this.businessName,
    this.emailAddress,
    this.phoneNumber,
    this.billingAddress,
    this.description,
    this.messageToClient,
    this.status,
    this.user,
    this.senderDetails,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String? ?? json['_id'] as String?,
      invoiceNumber: json['invoiceNumber'] as String?,
      invoiceAmount: (json['invoiceAmount'] is num)
          ? (json['invoiceAmount'] as num).toDouble()
          : double.tryParse(json['invoiceAmount']?.toString() ?? '0'),
      issueDate: json['issueDate'] != null
          ? DateTime.tryParse(json['issueDate'].toString())
          : null,
      dueDateType: json['dueDateType'] as String?,
      customDueDate: json['customDueDate'] != null
          ? DateTime.tryParse(json['customDueDate'].toString())
          : null,
      currency: json['currency'] as String?,
      clientName: json['clientName'] as String?,
      businessName: json['businessName'] as String?,
      emailAddress: json['emailAddress'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      billingAddress: json['billingAddress'] != null
          ? BillingAddressModel.fromJson(
              json['billingAddress'] as Map<String, dynamic>,
            )
          : null,
      description: json['description'] as String?,
      messageToClient: json['messageToClient'] as String?,
      status: json['status'] as String?,
      user: json['user'] as String?,
      senderDetails: json['senderDetails'] != null
          ? SenderDetailsModel.fromJson(
              json['senderDetails'] as Map<String, dynamic>,
            )
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'invoiceAmount': invoiceAmount ?? 0,
      'issueDate': issueDate?.toUtc().toIso8601String() ??
          DateTime.now().toUtc().toIso8601String(),
      'dueDateType': dueDateType ?? 'on_receipt',
      'clientName': clientName ?? '',
      'businessName': businessName ?? '',
      'emailAddress': emailAddress ?? '',
      'phoneNumber': phoneNumber ?? '',
      'billingAddress':
          billingAddress?.toJson() ?? BillingAddressModel().toJson(),
      'description': description ?? '',
      'messageToClient': messageToClient ?? '',
    };
    if (customDueDate != null) {
      data['customDueDate'] = customDueDate!.toUtc().toIso8601String();
    }
    return data;
  }
}

class InvoiceProfileModel {
  final String? id;
  final String? user;
  final String? businessName;
  final String? email;
  final String? phoneNumber;
  final String? website;
  final String? address;
  final String? logo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvoiceProfileModel({
    this.id,
    this.user,
    this.businessName,
    this.email,
    this.phoneNumber,
    this.website,
    this.address,
    this.logo,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceProfileModel.fromJson(Map<String, dynamic> json) {
    return InvoiceProfileModel(
      id: json['id'] as String? ?? json['_id'] as String?,
      user: json['user'] as String?,
      businessName: json['businessName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String?,
      logo: json['logo'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'businessName': businessName ?? '',
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'address': address ?? '',
    };

    if (website != null && website!.trim().isNotEmpty) {
      String formattedUrl = website!.trim();
      if (!formattedUrl.startsWith('http://') &&
          !formattedUrl.startsWith('https://')) {
        formattedUrl = 'https://$formattedUrl';
      }
      data['website'] = formattedUrl;
    }

    if (logo != null && logo!.trim().isNotEmpty) {
      data['logo'] = logo!.trim();
    }

    return data;
  }
}



