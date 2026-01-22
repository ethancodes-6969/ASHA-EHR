import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String colHouseholds = 'asha_households';
  static const String colMembers = 'asha_members';
  static const String colVisits = 'asha_visits';

  // Push
  Future<void> pushBatch(String collection, List<Map<String, dynamic>> docs) async {
    if (docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in docs) {
      final docRef = _firestore.collection(collection).doc(doc['id']);
      batch.set(docRef, doc);
    }
    await batch.commit();
  }

  // Pull
  Future<List<Map<String, dynamic>>> pullSince(
    String collection, 
    String deviceId, 
    int lastSyncTimestamp
  ) async {
    final snapshot = await _firestore
        .collection(collection)
        .where('owner_device_id', isEqualTo: deviceId)
        .where('updated_at', isGreaterThan: lastSyncTimestamp)
        .get();

    return snapshot.docs.map((d) => d.data()).toList();
  }
}
