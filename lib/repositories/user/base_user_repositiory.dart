
import 'package:flutter_app_instaclone/models/user_model.dart';

abstract class BaseUserRepository{

  Future<User> getUserWithId({String userId});
  Future<void> updateUser({User user});

}