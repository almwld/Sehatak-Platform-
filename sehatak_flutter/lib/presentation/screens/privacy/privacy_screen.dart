import 'package:flutter/material.dart';
import 'package:sehatak_flutter/core/constants/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('سياسة الخصوصية لتطبيق صحتك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 16),
              const Text(
                '1. جمع البيانات\nنقوم بجمع البيانات الأساسية مثل الاسم والبريد الإلكتروني ورقم الهاتف.\n\n'
                '2. استخدام البيانات\nنستخدم بياناتك لتقديم الخدمات الطبية وتحسين تجربتك.\n\n'
                '3. حماية البيانات\nنستخدم أحدث تقنيات التشفير لحماية بياناتك.\n\n'
                '4. مشاركة البيانات\nلا نشارك بياناتك مع أي طرف ثالث دون موافقتك.\n\n'
                '5. حقوقك\nيمكنك طلب حذف بياناتك في أي وقت.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
