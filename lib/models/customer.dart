import 'package:app_mobile_plusroom/models/landlord.dart';
import 'package:app_mobile_plusroom/models/roomie.dart';

class Customer {
  int id;
  Landlord landlord;
  Tenant tenant;
  Status status;

  Customer({
    required this.id,
    required this.landlord,
    required this.tenant,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      landlord: Landlord.fromJson(json['landlord']),
      tenant: Tenant.fromJson(json['tenant']),
      status: Status.values.firstWhere((e) => e.toString() == 'Status.' + json['status']),
    );
  }
}

enum Status {
  accepted,
  pending,
  rejected,
}