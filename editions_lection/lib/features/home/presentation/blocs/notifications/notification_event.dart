part of 'notification_bloc.dart';


class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {}

class StartNotificationPollingEvent extends NotificationEvent {}

class StopNotificationPollingEvent extends NotificationEvent {}



