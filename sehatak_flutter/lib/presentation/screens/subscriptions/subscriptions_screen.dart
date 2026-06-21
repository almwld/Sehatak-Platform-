import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../payment/subscription_payment_screen.dart';  // ✅ المسار الصحيح

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final List<Map<String, dynamic>> _plans = [
    {'id': 'basic', 'name': 'الباقة الأساسية', 'price': 99, 'features': ['استشارة واحدة', 'دردشة غير محدودة']},
    {'id': 'premium', 'name': 'الباقة المميزة', 'price': 199, 'features': ['استشارات غير محدودة', 'دردشة غير محدودة', 'متابعة طبية']},
    {'id': 'family', 'name': 'الباقة العائلية', 'price': 299, 'features': ['5 استشارات', 'دردشة غير محدودة', 'متابعة طبية', 'خصم العائلة']},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاشتراكات'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _plans.length,
        itemBuilder: (context, index) {
          final plan = _plans[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${plan['price']} ريال / شهرياً',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...plan['features'].map<Widget>((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(feature),
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubscriptionPaymentScreen(
                              planId: plan['id'],
                              planName: plan['name'],
                              price: plan['price'].toDouble(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('اشتراك الآن'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
