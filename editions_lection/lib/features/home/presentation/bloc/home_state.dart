part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MaterialEntity> books;
  final List<MaterialEntity> polycopies;

  const HomeLoaded({
    required this.books,
    required this.polycopies,
  });

  @override
  List<Object> get props => [books, polycopies];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object> get props => [message];
}