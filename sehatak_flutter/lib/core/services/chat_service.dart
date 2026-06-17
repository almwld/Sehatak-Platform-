import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 💬 إرسال رسالة نصية
  Future<void> sendTextMessage({
    required String chatId,
    required String content,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'id': messageRef.id,
      'type': 'text',
      'content': content,
      'senderId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    // تحديث آخر رسالة في المحادثة
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSender': user.uid,
    });
  }

  // 🖼️ إرسال صورة
  Future<void> sendImageMessage({
    required String chatId,
    required XFile image,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // رفع الصورة إلى Firebase Storage
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage
        .ref()
        .child('chats/$chatId/images/$fileName');
    
    await ref.putFile(File(image.path));
    final imageUrl = await ref.getDownloadURL();

    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'id': messageRef.id,
      'type': 'image',
      'content': imageUrl,
      'senderId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': '📷 صورة',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSender': user.uid,
    });
  }

  // 📎 إرسال ملف
  Future<void> sendFileMessage({
    required String chatId,
    required PlatformFile file,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // رفع الملف إلى Firebase Storage
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final ref = _storage
        .ref()
        .child('chats/$chatId/files/$fileName');
    
    await ref.putFile(File(file.path!));
    final fileUrl = await ref.getDownloadURL();

    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'id': messageRef.id,
      'type': 'file',
      'content': fileUrl,
      'fileName': file.name,
      'fileSize': file.size,
      'senderId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': '📎 ${file.name}',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSender': user.uid,
    });
  }

  // 👀 تحديد الرسائل كمقروءة
  Future<void> markMessagesAsRead(String chatId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: user.uid)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in messages.docs) {
      await doc.reference.update({'read': true});
    }
  }

  // 🔍 إنشاء معرف محادثة فريد
  String getChatId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return 'chat_${ids[0]}_${ids[1]}';
  }

  // 📋 الحصول على محادثات المستخدم
  Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // 💬 الحصول على رسائل محادثة
  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // 🗑️ حذف محادثة
  Future<void> deleteChat(String chatId) async {
    // حذف جميع الرسائل
    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    // حذف المحادثة
    await _firestore.collection('chats').doc(chatId).delete();
  }
}
