import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_instaclone/config/paths.dart';
import 'package:flutter_app_instaclone/models/notif_model.dart';
import 'package:flutter_app_instaclone/repositories/notification/base_notification_repository.dart';

class NotificationRepository extends BaseNotificationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<Notif>>> getUserNotifications({String userId}) {
    return _firebaseFirestore
        .collection(Paths.notifications)
        .doc(userId)
        .collection(Paths.userNotifications)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
            (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList());
  }
}
