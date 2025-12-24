import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/repair_job.dart';
import '../../auth/data/auth_service.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final jobServiceProvider = Provider<JobService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final user = ref.watch(authStateProvider).value;
  return JobService(firestore, user?.uid);
});

class JobService {
  final FirebaseFirestore _firestore;
  final String? _uid;

  JobService(this._firestore, this._uid);

  CollectionReference get _jobsRef => _firestore.collection('repair_jobs');

  Future<void> addJob(RepairJob job) async {
    if (_uid == null) throw Exception('User not authenticated');
    await _jobsRef.add(job.toMap());
  }

  Stream<List<RepairJob>> getDashboardJobs() {
    if (_uid == null) return Stream.value([]);
    
    return _jobsRef
        .where('technicianId', isEqualTo: _uid)
        .orderBy('serviceDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RepairJob.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Filtrado específico para el dashboard
  Stream<List<RepairJob>> getRecentJobs() {
     if (_uid == null) return Stream.value([]);
     
     // Obtenemos los trabajos del técnico actual
     return _jobsRef
        .where('technicianId', isEqualTo: _uid)
        .orderBy('serviceDate', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RepairJob.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
