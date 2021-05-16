
import 'package:flutter_app_instaclone/models/notif_model.dart';

abstract class BaseNotificationRepository{
  Stream<List<Future<Notif>>> getUserNotifications({String userId});
}