import 'package:bloc/bloc.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:editions_lection/features/home/domain/usecases/get_books.dart';
import 'package:editions_lection/features/home/domain/usecases/get_polycopies.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBooks getBooks;
  final GetPolycopies getPolycopies;

  HomeBloc({
    required this.getBooks,
    required this.getPolycopies,
  }) : super(HomeInitial()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());
      final booksResult = await getBooks(NoParams());
      final polycopiesResult = await getPolycopies(NoParams());

      booksResult.fold(
        (failure) => emit(HomeFailure(message: _mapFailureToMessage(failure))),
        (books) {
          polycopiesResult.fold(
            (failure) =>
                emit(HomeFailure(message: _mapFailureToMessage(failure))),
            (polycopies) =>
                emit(HomeLoaded(books: books, polycopies: polycopies)),
          );
        },
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else {
      return 'Unexpected error';
    }
  }
}
