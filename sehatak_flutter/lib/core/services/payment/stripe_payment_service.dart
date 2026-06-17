import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripePaymentService {
  static const String STRIPE_SECRET_KEY = 'sk_test_...';
  static const String STRIPE_PUBLISHABLE_KEY = 'pk_test_...';
  static const String BACKEND_URL = 'https://your-backend.com/create-payment-intent';

  StripePaymentService() {
    Stripe.publishableKey = STRIPE_PUBLISHABLE_KEY;
  }

  Future<PaymentIntentResult> createPaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
    required String customerEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(BACKEND_URL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (amount * 100).toInt(),
          'currency': currency,
          'orderId': orderId,
          'customerEmail': customerEmail,
          'metadata': {
            'platform': 'sehatak_app',
            'order_id': orderId,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentIntentResult(
          success: true,
          clientSecret: data['clientSecret'],
          paymentIntentId: data['paymentIntentId'],
        );
      } else {
        return PaymentIntentResult(
          success: false,
          errorMessage: 'فشل إنشاء طلب الدفع',
        );
      }
    } catch (e) {
      return PaymentIntentResult(
        success: false,
        errorMessage: 'حدث خطأ: $e',
      );
    }
  }

  Future<PaymentResult> confirmPayment({
    required String clientSecret,
    required PaymentMethodParams paymentMethodParams,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'صحتك - Sehatak',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return PaymentResult(
        success: true,
        message: 'تم الدفع بنجاح!',
        status: 'completed',
      );
    } on StripeException catch (e) {
      return PaymentResult(
        success: false,
        message: 'فشل الدفع: ${e.error.localizedMessage}',
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'حدث خطأ غير متوقع',
      );
    }
  }

  Future<PaymentResult> payWithCard({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
    required double amount,
    required String currency,
  }) async {
    try {
      final intent = await createPaymentIntent(
        amount: amount,
        currency: currency,
        orderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
        customerEmail: 'customer@example.com',
      );

      if (!intent.success) {
        return PaymentResult(
          success: false,
          message: intent.errorMessage ?? 'فشل إنشاء الدفع',
        );
      }

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: intent.clientSecret!,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodDataCard(
            cardNumber: cardNumber,
            expMonth: int.parse(expMonth),
            expYear: int.parse(expYear),
            cvc: cvc,
          ),
        ),
        options: PaymentMethodOptions(
          setupFutureUsage: PaymentIntentSetupFutureUsage.offSession,
        ),
      );

      return PaymentResult(
        success: true,
        message: 'تم الدفع بنجاح!',
        transactionId: intent.paymentIntentId,
        status: 'completed',
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'فشل الدفع: $e',
      );
    }
  }
}

class PaymentIntentResult {
  final bool success;
  final String? clientSecret;
  final String? paymentIntentId;
  final String? errorMessage;

  PaymentIntentResult({
    required this.success,
    this.clientSecret,
    this.paymentIntentId,
    this.errorMessage,
  });
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
