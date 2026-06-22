import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class MedicalReportsScreen extends StatefulWidget {
  const MedicalReportsScreen({super.key});

  @override
  State<MedicalReportsScreen> createState() => _MedicalReportsScreenState();
}

class _MedicalReportsScreenState extends State<MedicalReportsScreen> {
  final List<String> _types = ['الكل', 'تحاليل', 'أشعة', 'فحوصات'];
  String _selectedType = 'الكل';

  final List<Map<String, dynamic>> _reports = [
    {'title': 'تحليل الدم الشامل', 'date': DateTime.now().subtract(const Duration(days: 5)), 'status': 'طبيعي', 'doctor': 'د. أحمد', 'type': 'تحاليل'},
    {'title': 'صورة أشعة الصدر', 'date': DateTime.now().subtract(const Duration(days: 12)), 'status': 'يحتاج متابعة', 'doctor': 'د. سارة', 'type': 'أشعة'},
    {'title': 'فحص النظر', 'date': DateTime.now().subtract(const Duration(days: 20)), 'status': 'طبيعي', 'doctor': 'د. محمد', 'type': 'فحوصات'},
  ];

  List<Map<String, dynamic>> get _filtered => _selectedType == 'الكل' ? _reports : _reports.where((r) => r['type'] == _selectedType).toList();

  int get _total => _reports.length;
  int get _normal => _reports.where((r) => r['status'] == 'طبيعي').length;
  int get _abnormal => _reports.where((r) => r['status'] != 'طبيعي').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير الطبية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الإحصائيات
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _statItem(_total.toString(), 'الإجمالي', AppColors.primary),
                const SizedBox(width: 20),
                _statItem(_normal.toString(), 'طبيعي', AppColors.success),
                const SizedBox(width: 20),
                _statItem(_abnormal.toString(), 'يحتاج متابعة', AppColors.warning),
              ],
            ),
          ),
          // التصنيفات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types.map((t) {
                final selected = _selectedType == t;
                return ChoiceChip(
                  label: Text(t, style: const TextStyle(fontSize: 10)),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: selected ? Colors.white : AppColors.darkGrey),
                  onSelected: (v) => setState(() => _selectedType = v! ? t : 'الكل'),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // القائمة
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final r = _filtered[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      r['type'] == 'تحاليل' ? Icons.science : Icons.visibility,
                      color: AppColors.primary,
                    ),
                    title: Text(r['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${DateFormat('dd/MM/yyyy').format(r['date'])} - ${r['doctor']}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: r['status'] == 'طبيعي' ? AppColors.success.withOpacity(0.08) : AppColors.warning.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        r['status'],
                        style: TextStyle(
                          fontSize: 9,
                          color: r['status'] == 'طبيعي' ? AppColors.success : AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.upload_file, color: Colors.white),
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.grey)),
          ],
        ),
      ),
    );
  }
}
