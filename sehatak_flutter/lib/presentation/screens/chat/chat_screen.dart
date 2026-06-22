import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'text': 'مرحباً، كيف يمكنني مساعدتك؟', 'isMe': false, 'time': DateTime.now().subtract(const Duration(minutes: 5))},
    {'text': 'أريد حجز موعد مع د. علي', 'isMe': true, 'time': DateTime.now().subtract(const Duration(minutes: 3))},
    {'text': 'سأحجز لك موعداً الآن', 'isMe': false, 'time': DateTime.now().subtract(const Duration(minutes: 1))},
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشة'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? AppColors.primary : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                            color: msg['isMe'] ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(msg['time']),
                          style: TextStyle(
                            fontSize: 10,
                            color: msg['isMe'] ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'text': _controller.text,
                          'isMe': true,
                          'time': DateTime.now(),
                        });
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
