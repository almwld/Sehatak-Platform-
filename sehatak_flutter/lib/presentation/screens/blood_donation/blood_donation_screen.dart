import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BloodDonationScreen extends StatelessWidget {
  const BloodDonationScreen({super.key});

  final List<Map<String, dynamic>> _requests = const [
    {'name': 'أحمد محمد', 'blood': 'O+', 'city': 'صنعاء', 'available': true},
    {'name': 'فاطمة علي', 'blood': 'A+', 'city': 'صنعاء', 'available': true},
    {'name': 'محمد حسن', 'blood': 'B+', 'city': 'تعز', 'available': true},
    {'name': 'سارة عمر', 'blood': 'O-', 'city': 'عدن', 'available': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بنك الدم'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الأزرار الرئيسية
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.volunteer_activism),
                    label: const Text('سجل كمتبرع'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    label: const Text('ابحث عن متبرع'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // مخزون الدم
            const Text(
              'مخزون الدم الحالي',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _bloodType('O+', '45 كيس', AppColors.success),
                _bloodType('A+', '32 كيس', AppColors.info),
                _bloodType('B+', '28 كيس', AppColors.warning),
                _bloodType('AB+', '15 كيس', AppColors.purple),
                _bloodType('O-', '8 كيس', AppColors.error),
              ],
            ),
            const SizedBox(height: 20),
            // طلبات التبرع
            const Text(
              'طلبات التبرع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._requests.map((r) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  child: Text(
                    r['blood'][0],
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(r['name']),
                subtitle: Text('${r['city']} - فصيلة ${r['blood']}'),
                trailing: r['available']
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'متاح',
                          style: TextStyle(color: AppColors.success, fontSize: 10),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'مغلق',
                          style: TextStyle(color: AppColors.error, fontSize: 10),
                        ),
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _bloodType(String type, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
