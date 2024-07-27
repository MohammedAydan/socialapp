class PaymentMethodData {
  final String description;
  final Info info;
  final TokenizationData tokenizationData;
  final String type;

  PaymentMethodData({
    required this.description,
    required this.info,
    required this.tokenizationData,
    required this.type,
  });

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) {
    return PaymentMethodData(
      description: json['description'] ?? '',
      info: Info.fromJson(json['info'] ?? {}),
      tokenizationData:
          TokenizationData.fromJson(json['tokenizationData'] ?? {}),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'info': info.toJson(),
      'tokenizationData': tokenizationData.toJson(),
      'type': type,
    };
  }
}

class Info {
  final BillingAddress billingAddress;
  final String cardDetails;
  final String cardNetwork;

  Info({
    required this.billingAddress,
    required this.cardDetails,
    required this.cardNetwork,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      billingAddress: BillingAddress.fromJson(json['billingAddress'] ?? {}),
      cardDetails: json['cardDetails'] ?? '',
      cardNetwork: json['cardNetwork'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billingAddress': billingAddress.toJson(),
      'cardDetails': cardDetails,
      'cardNetwork': cardNetwork,
    };
  }
}

class BillingAddress {
  final String address1;
  final String address2;
  final String address3;
  final String administrativeArea;
  final String countryCode;
  final String locality;
  final String name;
  final String phoneNumber;
  final String postalCode;
  final String sortingCode;

  BillingAddress({
    required this.address1,
    required this.address2,
    required this.address3,
    required this.administrativeArea,
    required this.countryCode,
    required this.locality,
    required this.name,
    required this.phoneNumber,
    required this.postalCode,
    required this.sortingCode,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) {
    return BillingAddress(
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      address3: json['address3'] ?? '',
      administrativeArea: json['administrativeArea'] ?? '',
      countryCode: json['countryCode'] ?? '',
      locality: json['locality'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      postalCode: json['postalCode'] ?? '',
      sortingCode: json['sortingCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'administrativeArea': administrativeArea,
      'countryCode': countryCode,
      'locality': locality,
      'name': name,
      'phoneNumber': phoneNumber,
      'postalCode': postalCode,
      'sortingCode': sortingCode,
    };
  }
}

class TokenizationData {
  final String token;
  final String type;

  TokenizationData({
    required this.token,
    required this.type,
  });

  factory TokenizationData.fromJson(Map<String, dynamic> json) {
    return TokenizationData(
      token: json['token'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
    };
  }
}
