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
  final User? user;
  final List<MaterialEntity>? searchResults;

  const HomeLoaded({
    required this.books,
    required this.polycopies,
    this.user,
    this.searchResults,
  });

  @override
  List<Object> get props =>
      [books, polycopies, user ?? '', searchResults ?? []];

  HomeLoaded copyWith({
    List<MaterialEntity>? books,
    List<MaterialEntity>? polycopies,
    User? user,
    List<MaterialEntity>? searchResults,
  }) {
    return HomeLoaded(
      books: books ?? this.books,
      polycopies: polycopies ?? this.polycopies,
      user: user ?? this.user,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object> get props => [message];
}
