import 'package:flutter/material.dart';
import 'package:callwave_flutter/callwave_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/call_service.dart';

class CallScreen extends StatefulWidget {
  final String callId;
  final String callType; // 'audio' or 'video'

  const CallScreen({
    Key? key,
    required this.callId,
    required this.callType,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isVideoOn = true;
  bool _isSpeakerOn = false;
  Duration _callDuration = Duration.zero;
  late CallSession _session;

  @override
  void initState() {
    super.initState();
    _initializeCall();
  }

  Future<void> _initializeCall() async {
    _session = (await CallwaveFlutter.instance.getSession(widget.callId))!;
    
    // بدء تتبع مدة المكالمة
    _startCallTimer();
  }

  void _startCallTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _callDuration = _callDuration + Duration(seconds: 1);
        });
      }
      return mounted && _session.isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0077B6),
              Color(0xFF00B4D8),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 🎥 فيديو الطرف الآخر
              Positioned.fill(
                child: _buildRemoteVideo(),
              ),
              
              // 📹 فيديو المستخدم (صغير)
              Positioned(
                top: 60,
                right: 20,
                child: Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: _buildLocalVideo(),
                ),
              ),
              
              // ⬆️ معلومات المكالمة
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      _getCallerName(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 10)],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatDuration(_callDuration),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 10)],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 🎮 أزرار التحكم
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: _buildCallControls(),
              ),
              
              // ❌ زر إنهاء المكالمة
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => _endCall(),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎥 بناء فيديو الطرف البعيد
  Widget _buildRemoteVideo() {
    if (widget.callType == 'video') {
      return AgoraVideoView(
        client: CallService().engine,
        layout: VideoLayout.fit,
        zOrder: 0,
      );
    } else {
      // مكالمة صوتية - عرض صورة خلفية
      return Container(
        color: Color(0xFF0077B6),
        child: Center(
          child: Icon(
            Icons.person,
            size: 150,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      );
    }
  }

  // 📹 بناء فيديو المستخدم المحلي
  Widget _buildLocalVideo() {
    if (widget.callType == 'video' && _isVideoOn) {
      return AgoraVideoView(
        client: CallService().engine,
        videoRenderMode: VideoRenderMode.hidden,
        zOrder: 1,
        mirrorMode: true,
      );
    } else {
      return Center(
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.white54,
        ),
      );
    }
  }

  // 🎮 أزرار التحكم
  Widget _buildCallControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 🔊 كتم الميكروفون
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            color: _isMuted ? Colors.red : Colors.white,
            onTap: () => _toggleMute(),
          ),
          
          // 📷 إيقاف الفيديو
          if (widget.callType == 'video')
            _buildControlButton(
              icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
              color: _isVideoOn ? Colors.white : Colors.red,
              onTap: () => _toggleVideo(),
            ),
          
          // 🔊 مكبر الصوت
          _buildControlButton(
            icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
            color: _isSpeakerOn ? Colors.green : Colors.white,
            onTap: () => _toggleSpeaker(),
          ),
          
          // 📸 تبديل الكاميرا
          if (widget.callType == 'video')
            _buildControlButton(
              icon: Icons.switch_camera,
              color: Colors.white,
              onTap: () => _switchCamera(),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }

  // 🔄 دوال التحكم
  void _toggleMute() async {
    await CallService().toggleMute();
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleVideo() async {
    await CallService().toggleVideo();
    setState(() {
      _isVideoOn = !_isVideoOn;
    });
  }

  void _toggleSpeaker() async {
    await CallService().engine.setEnableSpeakerphone(!_isSpeakerOn);
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _switchCamera() async {
    await CallService().switchCamera();
  }

  void _endCall() async {
    await CallService().endCall(widget.callId);
    Navigator.pop(context);
  }

  String _getCallerName() {
    // يمكنك جلب اسم المستخدم من Firestore
    return 'طبيبك في صحتك';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
