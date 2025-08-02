import 'package:bloc/bloc.dart';
import 'package:editions_lection/core/errors/failure.dart';
//import 'package:editions_lection/core/usecase/usecase.dart';
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

      // Commented out the original backend calls
      // final booksResult = await getBooks(NoParams());
      // final polycopiesResult = await getPolycopies(NoParams());

      // Using fake data since the backend is not ready yet.
      // Simulating a network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final List<MaterialEntity> fakeBooks = [
        MaterialEntity(
          id: '1',
          title: 'Book Title 1',
          description: 'Description for book 1',
          fileUrl: 'https://covers.openlibrary.org/b/id/15094106-L.jpg',
          materialType: 'book',
          priceDzd: 1500.00,
          createdAt: DateTime.now(),
        ),
        MaterialEntity(
          id: '2',
          title: 'Book Title 2',
          description: 'Description for book 2',
          fileUrl: 'https://covers.openlibrary.org/b/id/15094106-L.jpg',
          materialType: 'book',
          priceDzd: 1200.00,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      final List<MaterialEntity> fakePolycopies = [
        MaterialEntity(
          id: '3',
          title: 'Polycopie Title 1',
          description: 'Description for polycopie 1',
          fileUrl: 'https://covers.openlibrary.org/b/id/15094106-L.jpg',
          materialType: 'polycopie',
          priceDzd: 500.00,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        MaterialEntity(
          id: '4',
          title: 'Polycopie Title 2',
          description: 'Description for polycopie 2',
          fileUrl: 'https://covers.openlibrary.org/b/id/15094106-L.jpg',
          materialType: 'polycopie',
          priceDzd: 750.00,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      // Emit the HomeLoaded state with fake data
      emit(HomeLoaded(books: fakeBooks, polycopies: fakePolycopies));

      // The original fold logic is no longer needed for fake data, but
      // for demonstration, here's how it would have looked.
      /*
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
      */
    });
  }

  // ignore: unused_element
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else {
      return 'Unexpected error';
    }
  }
}
