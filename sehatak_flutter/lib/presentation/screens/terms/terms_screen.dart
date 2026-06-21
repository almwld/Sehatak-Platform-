import 'package:flutter/material.dart';
import 'package:sehatak_flutter/core/constants/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشروط والأحكام'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('شروط استخدام تطبيق صحتك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 16),
                    const Text('1. قبول الشروط\nباستخدامك لتطبيق صحتك فإنك توافق على هذه الشروط والأحكام.\n\n2. الخدمات المقدمة\nيقدم التطبيق خدمات استشارات طبية، حجز مواعيد، صيدلية، وغيرها.\n\n3. المسؤولية\nالمعلومات المقدمة هي لأغراض توعوية ولا تغني عن استشارة الطبيب.\n\n4. الخصوصية\nنحن نحمي بياناتك ولا نشاركها مع أطراف ثالثة.\n\n5. التعديلات\nنحتفظ بالحق في تعديل هذه الشروط في أي وقت.'),
                  ],
                ),
              ),
            ),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)), child: const Text('أوافق على الشروط'))),
          ],
        ),
      ),
    );
  }
}
