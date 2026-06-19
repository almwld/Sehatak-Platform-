import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/theme/theme_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state is ThemeDark;
    
    return Scaffold(
      // ==============================================
      // 📱 AppBar
      // ==============================================
      appBar: AppBar(
        title: const Text(
          'صحتك',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 0,
        actions: [
          // زر تبديل الثيم
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: AppColors.primary,
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        ],
      ),
      
      // ==============================================
      // 📱 Body
      // ==============================================
      body: _buildBody(),
      
      // ==============================================
      // 📱 Bottom Navigation Bar
      // ==============================================
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // بطاقة الترحيب
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      size: 60,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'مرحباً بك في منصة صحتك',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الرعاية الصحية اليمنية الشاملة',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 24),
                    // أزرار الخدمات
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildServiceButton(
                          icon: Icons.medical_services,
                          label: 'الأطباء',
                          color: AppColors.primary,
                        ),
                        _buildServiceButton(
                          icon: Icons.local_pharmacy,
                          label: 'الصيدلية',
                          color: AppColors.success,
                        ),
                        _buildServiceButton(
                          icon: Icons.emergency,
                          label: 'الطوارئ',
                          color: AppColors.error,
                        ),
                        _buildServiceButton(
                          icon: Icons.science,
                          label: 'التحاليل',
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey[400],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'الأطباء',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_pharmacy),
          label: 'الصيدلية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'ملفي',
        ),
      ],
    );
  }
}
