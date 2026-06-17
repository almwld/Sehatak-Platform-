import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehatak/core/constants/app_colors.dart';
import 'package:sehatak/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'onboarding_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _fade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)));
    _scale = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _animCtrl, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)));
    _animCtrl.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final s = context.read<AuthBloc>().state;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => s is Authenticated ? const HomeScreen() : const OnboardingScreen()));
    });
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF00796B), Color(0xFF004D40), Color(0xFF00251A)])),
      child: Stack(children: [
        Positioned(top: -100, right: -100, child: TweenAnimationBuilder(tween: Tween<double>(begin: 0, end: 1), duration: const Duration(seconds: 2), builder: (_, v, __) => Transform.scale(scale: v, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))))),
        Positioned(bottom: -80, left: -80, child: TweenAnimationBuilder(tween: Tween<double>(begin: 0, end: 1), duration: const Duration(seconds: 2), builder: (_, v, __) => Transform.scale(scale: v, child: Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.03)))))),
        Center(child: AnimatedBuilder(animation: _animCtrl, builder: (_, child) => Opacity(opacity: _fade.value, child: Transform.scale(scale: _scale.value, child: child)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)])),
          const SizedBox(height: 24),
          const Text('SEHATAK', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3, fontFamily: 'Rubik')),
          const Text('صحتك', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo')),
          const Text('منصة الرعاية الصحية الشاملة', style: TextStyle(fontSize: 14, color: Colors.white70, fontFamily: 'Cairo')),
          const SizedBox(height: 40),
          SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)))),
        ]))),
        Positioned(bottom: 40, left: 0, right: 0, child: TweenAnimationBuilder(tween: Tween<double>(begin: 0, end: 1), duration: const Duration(seconds: 2), builder: (_, v, __) => Opacity(opacity: v, child: const Text('صحتك أولاً', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white30, letterSpacing: 2, fontFamily: 'Cairo'))))),
      ]),
    ),
  );
}
