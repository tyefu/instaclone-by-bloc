import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton(
      {Key key, @required this.isCurrentUser, @required this.isFollowing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(
            onPressed: () {},
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0),
            ),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
          )
        : ElevatedButton(
            onPressed: () {},
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(
                  fontSize: 16.0,
                  color: isFollowing ? Colors.black : Colors.white),
            ),
            style: isFollowing
                ? Colors.grey[300]
                : ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
          );
  }
}
