import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import '../../../../../core/usecase/usecase.dart';
import '../../../../../modules/notifications_service.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/usecases/get_notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  Timer? _pollingTimer;
  static const Duration _pollingDuration = Duration(minutes: 5);

  NotificationBloc({required this.getNotificationsUseCase})
      : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<StartNotificationPollingEvent>(_onStartPolling);
    on<StopNotificationPollingEvent>(_onStopPolling);
  }

  Future<void> _onFetchNotifications(
      FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    final result = await getNotificationsUseCase(NoParams());
    result.fold(
        (failure) => emit(NotificationError("Failed to fetch notifications}")),
        (notifications) {
      emit(NotificationLoaded(notifications));
      // Trigger local notifications for each new item
      if (notifications.isNotEmpty) {
        for (var notif in notifications) {
          _showLocalNotification(notif);
        }
      }
    });
  }

  void _onStartPolling(
      StartNotificationPollingEvent event, Emitter<NotificationState> emit) {
    _pollingTimer?.cancel();
    add(FetchNotificationsEvent());
    _pollingTimer = Timer.periodic(_pollingDuration, (timer) {
      add(FetchNotificationsEvent());
    });
  }

  void _onStopPolling(
      StopNotificationPollingEvent event, Emitter<NotificationState> emit) {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }

  Future<void> _showLocalNotification(NotificationEntity notif) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'nouveaux messages',
      channelDescription: 'notifications pour les nouveaux messages',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notif.id.hashCode,
      'Nouveau message',
      notif.message,
      platformDetails,
      payload: notif.id,
    );
  }
}
