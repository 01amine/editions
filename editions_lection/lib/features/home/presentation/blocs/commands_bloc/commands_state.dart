part of 'commands_bloc.dart';

@immutable
sealed class CommandsState extends Equatable {
  const CommandsState();
  @override
  List<Object> get props => [];
}

final class CommandsInitial extends CommandsState {}

final class CommandsLoading extends CommandsState {}

final class CommandsLoaded extends CommandsState {
  final List<OrderEntity> orders;
  final int deliveredCount;

  const CommandsLoaded({
    required this.orders,
    required this.deliveredCount,
  });

  @override
  List<Object> get props => [orders, deliveredCount];
}

final class CommandsFailure extends CommandsState {
  final String message;
  const CommandsFailure({required this.message});
  @override
  List<Object> get props => [message];
}

final class OrderCreatedSuccess extends CommandsState {
  final String message;
  const OrderCreatedSuccess({required this.message});
  @override
  List<Object> get props => [message];
}