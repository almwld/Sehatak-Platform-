import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sehatak/core/constants/app_colors.dart';

class DoctorBookingScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final double consultationPrice;
  const DoctorBookingScreen({super.key, required this.doctorId, this.doctorName = 'الطبيب', this.consultationPrice = 5000});

  @override
  State<DoctorBookingScreen> createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String? _time;
  String _type = 'clinic';
  final _notes = TextEditingController();
  bool _loading = false;
  final _morning = ['08:00', '09:00', '10:00', '11:00'];
  final _afternoon = ['13:00', '14:00', '15:00', '16:00'];
  final _evening = ['17:00', '18:00', '19:00', '20:00'];

  Future<void> _book() async {
    if (_time == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر الوقت'))); return; }
    setState(() => _loading = true);
    try {
      await _firestore.collection('appointments').add({
        'patientId': _auth.currentUser!.uid, 'patientName': _auth.currentUser?.displayName ?? 'مريض',
        'doctorId': widget.doctorId, 'doctorName': widget.doctorName,
        'date': '${_date.year}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}',
        'time': _time, 'type': _type, 'price': widget.consultationPrice,
        'status': 'pending', 'notes': _notes.text, 'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم الحجز!'), backgroundColor: AppColors.success)); Navigator.pop(context, true); }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ فشل'), backgroundColor: AppColors.error)); }
    finally { setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: Text('حجز - ${widget.doctorName}')),
    body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(16)), child: Row(children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.person, color: AppColors.primary, size: 30)),
        const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.doctorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('${widget.consultationPrice.toInt()} ريال', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))])),
      ])),
      const SizedBox(height: 20),
      const Text('نوع الاستشارة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 10),
      Row(children: [_typeCard('عيادة', 'clinic', Icons.local_hospital), const SizedBox(width: 8), _typeCard('مكالمة', 'voice', Icons.call), const SizedBox(width: 8), _typeCard('فيديو', 'video', Icons.videocam)]),
      const SizedBox(height: 20),
      const Text('اختر التاريخ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 10),
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: TableCalendar(
        firstDay: DateTime.now(), lastDay: DateTime.now().add(const Duration(days: 60)), focusedDay: _date,
        selectedDayPredicate: (d) => isSameDay(_date, d), onDaySelected: (d, _) => setState(() { _date = d; _time = null; }),
        locale: 'ar', calendarStyle: CalendarStyle(selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
      )),
      const SizedBox(height: 20),
      const Text('اختر الوقت', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 10),
      _timeRow('صباحاً', _morning), _timeRow('بعد الظهر', _afternoon), _timeRow('مساءً', _evening),
      const SizedBox(height: 16),
      TextField(controller: _notes, maxLines: 2, textAlign: TextAlign.right, decoration: InputDecoration(labelText: 'ملاحظات', border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), filled: true, fillColor: Colors.grey[50])),
      const SizedBox(height: 24),
      SizedBox(width: double.infinity, height: 54, child: ElevatedButton(onPressed: _loading ? null : _book, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: _loading ? const CircularProgressIndicator(color: Colors.white) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('تأكيد الحجز', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(width: 8), Text('(${widget.consultationPrice.toInt()} ريال)', style: const TextStyle(fontSize: 14))]))),
      const SizedBox(height: 30),
    ])),
  );

  Widget _typeCard(String l, String t, IconData i) {
    final sel = _type == t;
    return Expanded(child: GestureDetector(onTap: () => setState(() => _type = t), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: sel ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: sel ? AppColors.primary : AppColors.lightGrey)), child: Column(children: [Icon(i, color: sel ? Colors.white : AppColors.primary, size: 26), const SizedBox(height: 4), Text(l, style: TextStyle(color: sel ? Colors.white : AppColors.darkGrey, fontWeight: FontWeight.bold, fontSize: 12))]))));
  }

  Widget _timeRow(String p, List<String> slots) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p, style: const TextStyle(color: AppColors.grey, fontSize: 12)), const SizedBox(height: 6), Wrap(spacing: 8, runSpacing: 8, children: slots.map((t) => GestureDetector(onTap: () => setState(() => _time = t), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: _time == t ? AppColors.primary : Colors.grey[100], borderRadius: BorderRadius.circular(10), border: Border.all(color: _time == t ? AppColors.primary : Colors.grey[300]!)), child: Text(t, style: TextStyle(fontWeight: FontWeight.bold, color: _time == t ? Colors.white : AppColors.darkGrey, fontSize: 13))))).toList())]));
}
