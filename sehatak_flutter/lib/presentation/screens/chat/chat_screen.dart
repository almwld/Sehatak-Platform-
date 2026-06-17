import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../core/services/chat_service.dart';

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
  final ScrollController _scrollController = ScrollController();
  late String _chatId;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    _chatId = _chatService.getChatId(userId, widget.doctorId);
    _ensureChatExists();
  }

  Future<void> _ensureChatExists() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatId)
        .get();

    if (!chatDoc.exists) {
      await FirebaseFirestore.instance.collection('chats').doc(_chatId).set({
        'id': _chatId,
        'participants': [userId, widget.doctorId],
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
              radius: 18,
              backgroundColor: Colors.green[100],
              child: Text(
                widget.doctorName[0].toUpperCase(),
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctorName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'متصل الآن',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatService.getChatMessages(_chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'ابدأ المحادثة مع ${widget.doctorName}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
    final content = message['content'] ?? '';
    final time = (message['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.green[100],
              child: Text(
                widget.doctorName[0].toUpperCase(),
                style: const TextStyle(color: Colors.green, fontSize: 10),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.green[400] : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('hh:mm a').format(time),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                textDirection: TextDirection.rtl,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
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

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
