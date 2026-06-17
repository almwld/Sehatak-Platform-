import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PatientAppointments extends StatefulWidget {
  const PatientAppointments({super.key});

  @override
  State<PatientAppointments> createState() => _PatientAppointmentsState();
}

class _PatientAppointmentsState extends State<PatientAppointments>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواعيدي'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'القادمة'),
            Tab(text: 'السابقة'),
          ],
          labelColor: const Color(0xFF0077B6),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF0077B6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(status: 'pending'),
          _buildAppointmentsList(status: 'completed'),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList({required String status}) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('patientId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('date', descending: status == 'pending' ? false : true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data!.docs;
        if (appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 60,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  status == 'pending'
                      ? 'لا توجد مواعيد قادمة'
                      : 'لا توجد مواعيد سابقة',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final data = appointments[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: status == 'pending'
                      ? const Color(0xFF0077B6).withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  child: Icon(
                    status == 'pending' ? Icons.schedule : Icons.check_circle,
                    color: status == 'pending'
                        ? const Color(0xFF0077B6)
                        : Colors.green,
                  ),
                ),
                title: Text(data['doctorName'] ?? 'طبيب'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['specialty'] ?? ''),
                    Text(
                      DateFormat('dd/MM/yyyy - hh:mm a')
                          .format((data['date'] as Timestamp).toDate()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: status == 'pending'
                    ? IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _cancelAppointment(appointments[index].id),
                      )
                    : const Icon(Icons.chevron_right),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الموعد'),
        content: const Text('هل أنت متأكد من إلغاء هذا الموعد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('نعم', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'cancelled'});
    }
  }
}
