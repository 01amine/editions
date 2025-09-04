import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/home/domain/entities/order.dart';
import 'package:editions_lection/features/home/domain/usecases/create_order.dart';
import 'package:editions_lection/features/home/domain/usecases/get_orders.dart';

part 'commands_event.dart';
part 'commands_state.dart';

class CommandsBloc extends Bloc<CommandsEvent, CommandsState> {
  final GetOrders getOrders;
  final CreateOrder createOrder;

  CommandsBloc({
    required this.getOrders,
    required this.createOrder,
  }) : super(CommandsInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onFetchOrders(
    FetchOrdersEvent event,
    Emitter<CommandsState> emit,
  ) async {
    emit(CommandsLoading());
    final result = await getOrders(NoParams());
    result.fold(
      (failure) =>
          emit(CommandsFailure(message: _mapFailureToMessage(failure))),
      (orders) {
        final deliveredCount = orders
            .where((order) =>
                order.status == 'ready' || order.status == 'delivered')
            .length;
        emit(CommandsLoaded(orders: orders, deliveredCount: deliveredCount));
      },
    );
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<CommandsState> emit,
  ) async {
    emit(CommandsLoading());
    final result = await createOrder(
      CreateOrderParams(
        orders: event.orders,
        deliveryType: event.deliveryType,
        deliveryAddress: event.deliveryAddress,
        deliveryPhone: event.deliveryPhone,
      ),
    );
    result.fold(
      (failure) =>
          emit(CommandsFailure(message: _mapFailureToMessage(failure))),
      (success) => emit(
          const OrderCreatedSuccess(message: 'Order created successfully')),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return 'Could not retrieve data from local storage';
    } else {
      return 'An unexpected error occurred';
    }
  }
}