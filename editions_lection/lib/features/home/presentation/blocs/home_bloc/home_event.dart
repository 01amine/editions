part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeData extends HomeEvent {}

class SearchMaterialsEvent extends HomeEvent {
  final String query;

  const SearchMaterialsEvent({required this.query});

  @override
  List<Object> get props => [query];
}
