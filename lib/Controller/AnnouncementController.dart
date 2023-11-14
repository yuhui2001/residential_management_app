// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementController {
  final CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection("Announcement");

  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.orderBy("Announcement_ID", descending: true).get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting announcements: $e");
      return [];
    }
  }

  List<String> getTypes() {
    return ['Random', 'Security'];
  }
}
