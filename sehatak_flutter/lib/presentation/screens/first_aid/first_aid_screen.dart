import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  final List<Map<String, String>> _tips = const [
    {'title': 'الجروح', 'desc': 'نظف الجرح بالماء والصابون، ضع ضمادة معقمة'},
    {'title': 'الحروق', 'desc': 'ضع الماء البارد على الحرق لمدة 10 دقائق'},
    {'title': 'الكسور', 'desc': 'ثبت المنطقة المصابة، لا تحركها'},
    {'title': 'الإغماء', 'desc': 'ارفع القدمين، أرخِ الملابس الضيقة'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإسعافات الأولية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tips.length,
        itemBuilder: (context, index) {
          final item = _tips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.medical_services, color: AppColors.primary),
              title: Text(
                item['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['desc']!),
            ),
          );
        },
      ),
    );
  }
}
