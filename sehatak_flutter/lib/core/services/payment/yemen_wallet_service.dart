import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YemenWalletService {
  static const String MEPS_API_URL = 'https://api.mepsyemen.com/v1';
  static const String MERCHANT_ID = 'YOUR_MERCHANT_ID';
  static const String API_KEY = 'YOUR_API_KEY';

  Future<PaymentResult> payWithNationalWallet({
    required String phoneNumber,
    required double amount,
    required String orderId,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$MEPS_API_URL/payment/initiate'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': API_KEY,
          'X-Merchant-ID': MERCHANT_ID,
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'amount': amount,
          'orderId': orderId,
          'description': description,
          'callbackUrl': 'https://sehatak.app/payment/callback',
          'returnUrl': 'sehatak://payment/result',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          transactionId: data['transactionId'],
          status: data['status'],
          message: 'تم إرسال طلب الدفع إلى المحفظة الوطنية',
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'فشل الاتصال بالمحفظة الوطنية',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  Future<PaymentResult> payWithFloosak({
    required String phoneNumber,
    required double amount,
    required String orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$MEPS_API_URL/payment/floosak'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': API_KEY,
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'amount': amount,
          'orderId': orderId,
          'provider': 'FLOOSAK',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          transactionId: data['transactionId'],
          status: 'pending',
          message: 'تم إرسال طلب الدفع عبر فلوسك',
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'فشل الدفع عبر فلوسك',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  Future<PaymentResult> payWithJawali({
    required String phoneNumber,
    required double amount,
    required String orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$MEPS_API_URL/payment/jawali'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': API_KEY,
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'amount': amount,
          'orderId': orderId,
          'provider': 'JAWALI',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          transactionId: data['transactionId'],
          status: 'pending',
          message: 'تم إرسال طلب الدفع عبر جوالي',
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'فشل الدفع عبر جوالي',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  Future<PaymentResult> payWithWalletQR({
    required String qrCode,
    required double amount,
    required String orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$MEPS_API_URL/payment/qr'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': API_KEY,
        },
        body: jsonEncode({
          'qrCode': qrCode,
          'amount': amount,
          'orderId': orderId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          transactionId: data['transactionId'],
          status: 'completed',
          message: 'تم الدفع بنجاح عبر الكود السريع',
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'فشل الدفع عبر الكود السريع',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'حدث خطأ: $e',
      );
    }
  }

  Future<PaymentStatus> checkPaymentStatus(String transactionId) async {
    final response = await http.get(
      Uri.parse('$MEPS_API_URL/payment/status/$transactionId'),
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': API_KEY,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaymentStatus(
        transactionId: transactionId,
        status: data['status'],
        amount: data['amount'],
        completedAt: data['completedAt'] != null
            ? DateTime.parse(data['completedAt'])
            : null,
      );
    } else {
      return PaymentStatus(
        transactionId: transactionId,
        status: 'unknown',
        amount: 0,
      );
    }
  }
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? status;
  final String message;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.status,
    required this.message,
  });
}

class PaymentStatus {
  final String transactionId;
  final String status;
  final double amount;
  final DateTime? completedAt;

  PaymentStatus({
    required this.transactionId,
    required this.status,
    required this.amount,
    this.completedAt,
  });
}
