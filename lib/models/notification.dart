import 'package:app_mobile_plusroom/models/roomie.dart';

import 'landlord.dart';

class RentNotification {
  int id;
  List<Tenant> tenants;
  Landlord landlord;
  int postId;
  DateTime date;

  RentNotification({
    required this.id,
    required this.tenants,
    required this.landlord,
    required this.postId,
    required this.date,
  });

  factory RentNotification.fromJson(Map<String, dynamic> json) {
    return RentNotification(
      id: json['id'],
      tenants: json['tenants'].map((tenant) => Tenant.fromJson(tenant)).toList(),
      landlord: Landlord.fromJson(json['landlord']),
      postId: json['postId'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenants': tenants.map((tenant) => tenant.toJson()).toList(),
      'landlord': landlord.toJson(),
      'postId': postId,
      'date': date.toIso8601String(),
    };
  }
}