import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_instaclone/config/paths.dart';
import 'package:flutter_app_instaclone/enums/notif_type.dart';
import 'package:flutter_app_instaclone/models/notif_model.dart';
import 'package:flutter_app_instaclone/models/user_model.dart';
import 'package:flutter_app_instaclone/repositories/user/base_user_repositiory.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({@required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({@required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({@required String query}) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .get();
    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void followUser({@required String userId, @required String followUserId}) {
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});

    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});

    final notification = Notif(
        type: NotifType.follow,
        fromUser: User.empty.copyWith(id: userId),
        date: DateTime.now());
    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(followUserId)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }


  @override
  Future<bool> isFollowing(
      {@required String userId, @required String otherUserId}) async {
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }

  @override
  void unfollowUser(
      {@required String userId, @required String unfollowUserId}) {
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        .delete();

    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }
}
