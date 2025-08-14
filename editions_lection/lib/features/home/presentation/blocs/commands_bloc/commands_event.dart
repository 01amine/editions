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
  const CreateOrderEvent({required this.orders});
  @override
  List<Object> get props => [orders];
}