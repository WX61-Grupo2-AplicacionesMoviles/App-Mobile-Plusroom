import 'package:app_mobile_plusroom/models/roomie.dart';

import 'landlord.dart';

class Notification {
  final int id;
  final List<Tenant> tenant;
  final Landlord landlord;
  final int postId;
  final String date;

  Notification({
    required this.id,
    required this.tenant,
    required this.landlord,
    required this.postId,
    required this.date,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      tenant: (json['tenant'] as List)
          .map((tenantJson) => Tenant.fromJson(tenantJson))
          .toList(),
      landlord: Landlord.fromJson(json['landlord']),
      postId: json['postId'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant': tenant.map((t) => t.toJson()).toList(),
      'landlord': landlord.toJson(),
      'postId': postId,
      'date': date,
    };
  }
}

