import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_app_instaclone/models/failure_model.dart';
import 'package:flutter_app_instaclone/models/notif_model.dart';
import 'package:flutter_app_instaclone/repositories/notification/notification_repository.dart';
import 'package:flutter_app_instaclone/bloc/auth/auth_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Notif>>> _notificationsSubscription;

  NotificationsBloc({
    @required NotificationRepository notificationRepository,
    @required AuthBloc authBloc,
  })  : _notificationRepository = notificationRepository,
        _authBloc = authBloc,
        super(NotificationsState.initial()) {
    _notificationsSubscription?.cancel();
    _notificationsSubscription = _notificationRepository
        .getUserNotifications(userId: _authBloc.state.user.uid)
        .listen((notifications) async {
      final allNotifications = await Future.wait(notifications);
      add(NotificationsUpdateNotifications(notifications: allNotifications));
    });
  }

  @override
  Future<void> close() {
    _notificationsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is NotificationsUpdateNotifications) {
      yield* _mapNotificationsUpdateNotificationsToState(event);
    }
  }

  Stream<NotificationsState> _mapNotificationsUpdateNotificationsToState(
      NotificationsUpdateNotifications event,
      ) async* {
    yield state.copyWith(
      notifications: event.notifications,
      status: NotificationsStatus.loaded,
    );
  }
}
