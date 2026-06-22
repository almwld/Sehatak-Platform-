import 'package:flutter/material.dart';
import 'package:sehatak_flutter/core/constants/app_colors.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, String>> _faqs = [
    {'q': 'كيف أحجز موعداً؟', 'a': 'اضغط على زر "المواعيد" ثم اختر الطبيب والوقت المناسب.'},
    {'q': 'كيف أتواصل مع الطبيب؟', 'a': 'استخدم خدمة الدردشة أو المكالمات المتوفرة في التطبيق.'},
    {'q': 'هل البيانات آمنة؟', 'a': 'نعم، كل بياناتك مشفرة ومحمية وفق أعلى المعايير.'},
    {'q': 'كيف أستعيد كلمة المرور؟', 'a': 'استخدم خدمة "نسيت كلمة المرور" في صفحة تسجيل الدخول.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز المساعدة'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'ابحث في الأسئلة الشائعة...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._faqs.map((f) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ExpansionTile(
                title: Text(
                  f['q']!,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Text(
                      f['a']!,
                      style: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'لم تجد ما تبحث عنه؟',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('تواصل مع الدعم'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
