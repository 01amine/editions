part of 'commands_bloc.dart';

@immutable
sealed class CommandsEvent extends Equatable {
  const CommandsEvent();
  @override
  List<Object> get props => [];
}

final class FetchOrdersEvent extends CommandsEvent {}

final class CreateOrderEvent extends CommandsEvent {
  final List<OrderCreateEntity> orders;
  final DeliveryType deliveryType;
  final String? deliveryAddress;
  final String? deliveryPhone;

  const CreateOrderEvent({
    required this.orders,
    required this.deliveryType,
    this.deliveryAddress,
    this.deliveryPhone,
  });

  @override
  List<Object> get props =>
      [orders, deliveryType, deliveryAddress ?? '', deliveryPhone ?? ''];
}