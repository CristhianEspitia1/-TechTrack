import 'package:cloud_firestore/cloud_firestore.dart';

class RepairJob {
  final String? id;
  final String technicianId;
  final String customerName;
  final DateTime serviceDate;
  final double totalPrice;
  final double partsCost;
  final double diagnosticFee;

  RepairJob({
    this.id,
    required this.technicianId,
    required this.customerName,
    required this.serviceDate,
    required this.totalPrice,
    required this.partsCost,
    this.diagnosticFee = 70.0,
  });

  double get netProfit => totalPrice - partsCost;

  Map<String, dynamic> toMap() {
    return {
      'technicianId': technicianId,
      'customerName': customerName,
      'serviceDate': Timestamp.fromDate(serviceDate),
      'totalPrice': totalPrice,
      'partsCost': partsCost,
      'diagnosticFee': diagnosticFee,
    };
  }

  factory RepairJob.fromMap(String id, Map<String, dynamic> map) {
    return RepairJob(
      id: id,
      technicianId: map['technicianId'] ?? '',
      customerName: map['customerName'] ?? '',
      serviceDate: (map['serviceDate'] as Timestamp).toDate(),
      totalPrice: (map['totalPrice'] as num).toDouble(),
      partsCost: (map['partsCost'] as num).toDouble(),
      diagnosticFee: (map['diagnosticFee'] as num?)?.toDouble() ?? 70.0,
    );
  }
}
