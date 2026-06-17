import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/call_service.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const ChatScreen({
    Key? key,
    required this.doctorId,
    required this.doctorName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ImagePicker _imagePicker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  late String _chatId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final doctorId = widget.doctorId;
    _chatId = _chatService.getChatId(userId, doctorId);
    _ensureChatExists();
  }

  Future<void> _ensureChatExists() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final doctorId = widget.doctorId;
    
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .get();

    if (!chatDoc.exists) {
      await FirebaseFirestore.instance.collection('chats').doc(_chatId).set({
        'id': _chatId,
        'participants': [userId, doctorId],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green[100],
              child: Text(
                widget.doctorName[0].toUpperCase(),
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctorName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'متصل الآن',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
            // 📞 زر المكالمة
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () => _startCall('audio'),
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: () => _startCall('video'),
              color: Colors.blue,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                image: DecorationImage(
                  image: AssetImage('assets/images/chat_background.png'),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatService.getChatMessages(_chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey[300]),
                          SizedBox(height: 16),
                          Text(
                            'ابدأ المحادثة مع ${widget.doctorName}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  // تحديد الرسائل كمقروءة
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _chatService.markMessagesAsRead(_chatId);
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final data = message.data() as Map<String, dynamic>;
                      return _buildMessageBubble(data);
                    },
                  );
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final isMe = message['senderId'] == userId;
    final type = message['type'] ?? 'text';
    final content = message['content'] ?? '';
    final time = (message['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green[100],
              child: Text(
                widget.doctorName[0].toUpperCase(),
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.green[400] : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isMe ? Radius.circular(16) : Radius.circular(4),
                  bottomRight: isMe ? Radius.circular(4) : Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageContent(type, content, isMe),
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(time),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (isMe && message['read'] == true) ...[
                        SizedBox(width: 4),
                        Icon(Icons.done_all, size: 12, color: Colors.white70),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageContent(String type, String content, bool isMe) {
    switch (type) {
      case 'image':
        return GestureDetector(
          onTap: () => _showImagePreview(content),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: content,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 200,
                height: 200,
                color: Colors.grey[200],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 200,
                height: 200,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, color: Colors.grey[400]),
              ),
            ),
          ),
        );
      case 'file':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.insert_drive_file, color: isMe ? Colors.white70 : Colors.grey),
            SizedBox(height: 4),
            Text(
              message['fileName'] ?? 'ملف',
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            Text(
              '${(message['fileSize'] ?? 0) ~/ 1024} KB',
              style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey[600]),
            ),
          ],
        );
      default:
        return Text(
          content,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        );
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 📎 زر إرفاق ملف
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey[600]),
            onPressed: () => _pickFile(),
          ),
          // 🖼️ زر إرفاق صورة
          IconButton(
            icon: Icon(Icons.image, color: Colors.grey[600]),
            onPressed: () => _pickImage(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                textDirection: TextDirection.rtl,
                onSubmitted: (text) => _sendMessage(),
              ),
            ),
          ),
          // 📤 زر إرسال
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔄 دوال الإرسال
  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _chatService.sendTextMessage(
      chatId: _chatId,
      content: content,
    );
    _messageController.clear();
    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _chatService.sendImageMessage(
        chatId: _chatId,
        image: image,
      );
      _scrollToBottom();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      await _chatService.sendFileMessage(
        chatId: _chatId,
        file: result.files.first,
      );
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showImagePreview(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 📞 بدء مكالمة
  void _startCall(String callType) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    await CallService().startCall(
      doctorId: widget.doctorId,
      patientId: userId,
      callType: callType,
    );
    // التنقل لشاشة المكالمة
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CallScreen(...)));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
