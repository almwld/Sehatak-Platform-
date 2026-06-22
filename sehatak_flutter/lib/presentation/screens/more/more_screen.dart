import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../health/health_dashboard.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';
import '../about/about_screen.dart';
import '../contact_us/contact_us_screen.dart';
import '../help_center/help_center_screen.dart';
import '../rate_app/rate_app_screen.dart';
import '../share_app/share_app_screen.dart';
import '../reports/reports_dashboard.dart';
import '../medical_reports/medical_reports_screen.dart';
import '../health_shop/health_shop_screen.dart';
import '../blood_donation/blood_donation_screen.dart';
import '../emergencies/emergency_numbers.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المزيد'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخدمات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _serviceItem(context, Icons.health_and_safety, 'صحتي', AppColors.primary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthDashboard()))),
                _serviceItem(context, Icons.settings, 'الإعدادات', AppColors.secondary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
                _serviceItem(context, Icons.person, 'الملف الشخصي', AppColors.info, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))),
                _serviceItem(context, Icons.info, 'عن التطبيق', AppColors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
                _serviceItem(context, Icons.contact_mail, 'تواصل معنا', AppColors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()))),
                _serviceItem(context, Icons.help, 'المساعدة', AppColors.warning, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen()))),
                _serviceItem(context, Icons.star, 'تقييم التطبيق', AppColors.amber, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RateAppScreen()))),
                _serviceItem(context, Icons.share, 'مشاركة التطبيق', AppColors.indigo, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShareAppScreen()))),
                _serviceItem(context, Icons.receipt_long, 'التقارير', AppColors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsDashboard()))),
                _serviceItem(context, Icons.medical_services, 'التقارير الطبية', AppColors.pink, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalReportsScreen()))),
                _serviceItem(context, Icons.shopping_bag, 'متجر صحي', AppColors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthShopScreen()))),
                _serviceItem(context, Icons.bloodtype, 'بنك الدم', AppColors.error, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BloodDonationScreen()))),
                _serviceItem(context, Icons.directions_car, 'إسعاف', AppColors.warning, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyNumbers()))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.darkGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
