import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app.dart';
import 'core/services/call_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🔥 تهيئة Firebase
  await Firebase.initializeApp();
  
  // 📞 تهيئة خدمة المكالمات
  await CallService().initialize();
  
  // 🔔 تهيئة خدمة الإشعارات
  await NotificationService().initialize();
  
  // 📱 طلب صلاحيات الإشعارات
  await FirebaseMessaging.instance.requestPermission();
  
  // 🔔 التعامل مع الإشعارات في الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  runApp(SehatakApp());
}

// 🔔 معالج الإشعارات في الخلفية
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService().handleBackgroundMessage(message);
}
