import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String orderId;
  final String userId;
  final double amount;
  final String currency;
  final String method;
  final String? walletProvider;
  final String? cardLast4;
  final String status;
  final String? transactionId;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.method,
    this.walletProvider,
    this.cardLast4,
    required this.status,
    this.transactionId,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
    this.metadata = const {},
  });

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: doc.id,
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'YER',
      method: data['method'] ?? 'wallet',
      walletProvider: data['walletProvider'],
      cardLast4: data['cardLast4'],
      status: data['status'] ?? 'pending',
      transactionId: data['transactionId'],
      errorMessage: data['errorMessage'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      metadata: data['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'method': method,
      'walletProvider': walletProvider,
      'cardLast4': cardLast4,
      'status': status,
      'transactionId': transactionId,
      'errorMessage': errorMessage,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'metadata': metadata,
    };
  }
}
