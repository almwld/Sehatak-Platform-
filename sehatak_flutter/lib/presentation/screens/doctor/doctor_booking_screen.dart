import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DoctorBookingScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const DoctorBookingScreen({
    Key? key,
    required this.doctorId,
    required this.doctorName,
  }) : super(key: key);

  @override
  State<DoctorBookingScreen> createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _selectedTime = 'صباحاً';
  String _consultationType = 'عيادة';
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  final List<String> _timeSlots = ['صباحاً', 'ظهراً', 'مساءً'];
  final List<String> _consultationTypes = ['عيادة', 'مكالمة', 'فيديو'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حجز موعد مع ${widget.doctorName}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // التقويم
            Card(
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 30)),
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF0077B6),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                locale: 'ar',
              ),
            ),
            const SizedBox(height: 20),

            // اختيار الوقت
            const Text(
              'اختر الوقت',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _timeSlots.map((time) {
                return ChoiceChip(
                  label: Text(time),
                  selected: _selectedTime == time,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  selectedColor: const Color(0xFF0077B6),
                  labelStyle: TextStyle(
                    color: _selectedTime == time ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // نوع الاستشارة
            const Text(
              'نوع الاستشارة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _consultationTypes.map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _consultationType == type,
                  onSelected: (selected) {
                    setState(() {
                      _consultationType = type;
                    });
                  },
                  selectedColor: const Color(0xFF0077B6),
                  labelStyle: TextStyle(
                    color: _consultationType == type ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ملاحظات
            const Text(
              'ملاحظات إضافية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'أضف أي ملاحظات...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 30),

            // زر الحجز
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'احجز الآن',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _bookAppointment() async {
    setState(() => _isLoading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى تسجيل الدخول أولاً')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final appointmentData = {
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'patientId': userId,
        'date': Timestamp.fromDate(_selectedDay),
        'time': _selectedTime,
        'consultationType': _consultationType,
        'notes': _notesController.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointmentData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم حجز الموعد بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
