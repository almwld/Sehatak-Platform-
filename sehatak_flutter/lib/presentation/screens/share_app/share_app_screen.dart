import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sehatak_flutter/core/constants/app_colors.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشاركة التطبيق'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.share, color: Colors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'شارك صحتك مع أصدقائك',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ساعد أهلك في الوصول لرعاية صحية أفضل',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _shareOption(
              'مشاركة الرابط',
              Icons.link,
              AppColors.primary,
              Colors.blue.shade50,
              () {
                Share.share('حمل تطبيق صحتك - منصة الرعاية الصحية اليمنية الشاملة');
              },
            ),
            const SizedBox(height: 12),
            _shareOption(
              'رمز QR',
              Icons.qr_code,
              AppColors.dark,
              Colors.grey.shade100,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم عرض رمز QR قريباً')),
                );
              },
            ),
            const SizedBox(height: 12),
            _shareOption(
              'واتساب',
              Icons.message,
              const Color(0xFF25D366),
              const Color(0xFFE8FFF0),
              () {
                Share.share('حمل تطبيق صحتك https://play.google.com/store/apps/details?id=com.sehatak.app');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(String label, IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.12),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: iconColor),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: iconColor),
          ],
        ),
      ),
    );
  }
}
