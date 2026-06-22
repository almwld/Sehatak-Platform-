import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class MedicalReportsScreen extends StatefulWidget {
  const MedicalReportsScreen({super.key});

  @override
  State<MedicalReportsScreen> createState() => _MedicalReportsScreenState();
}

class _MedicalReportsScreenState extends State<MedicalReportsScreen> {
  final List<Map<String, dynamic>> _reports = [
    {'title': 'فحص دم شامل', 'date': DateTime.now().subtract(const Duration(days: 5)), 'doctor': 'د. علي المولد', 'status': 'جاهز'},
    {'title': 'تحليل سكر', 'date': DateTime.now().subtract(const Duration(days: 12)), 'doctor': 'د. حسن رضا', 'status': 'جاهز'},
    {'title': 'صورة أشعة', 'date': DateTime.now().subtract(const Duration(days: 20)), 'doctor': 'د. أحمد محمود', 'status': 'قيد المراجعة'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير الطبية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final r = _reports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(Icons.medical_services, color: AppColors.primary),
              ),
              title: Text(
                r['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${DateFormat('dd/MM/yyyy').format(r['date'])} - ${r['doctor']}',
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: r['status'] == 'جاهز' ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  r['status'],
                  style: TextStyle(
                    color: r['status'] == 'جاهز' ? AppColors.success : AppColors.warning,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
