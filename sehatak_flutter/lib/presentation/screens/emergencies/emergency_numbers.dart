import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../first_aid/first_aid_screen.dart';

class EmergencyNumbers extends StatelessWidget {
  const EmergencyNumbers({super.key});

  final List<Map<String, String>> _emergencies = const [
    {'name': 'الطوارئ العامة', 'number': '191', 'icon': '🚑'},
    {'name': 'الإسعاف', 'number': '997', 'icon': '🚨'},
    {'name': 'الدفاع المدني', 'number': '998', 'icon': '🧯'},
    {'name': 'الشرطة', 'number': '199', 'icon': '👮'},
    {'name': 'النجدة', 'number': '194', 'icon': '🚓'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أرقام الطوارئ'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _emergencies.length,
              itemBuilder: (context, index) {
                final item = _emergencies[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(
                      item['icon']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      item['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'رقم: ${item['number']}',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // TODO: تنفيذ الاتصال
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('اتصال'),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FirstAidScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'الإسعافات الأولية',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
