import 'package:bloc/bloc.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:editions_lection/features/home/domain/usecases/get_books.dart';
import 'package:editions_lection/features/home/domain/usecases/get_polycopies.dart';
import 'package:equatable/equatable.dart';

import '../../../../auth/domain/entities/user.dart';
import '../../../../auth/domain/usecases/get_current_user.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBooks getBooks;
  final GetPolycopies getPolycopies;
  final GetCurrentUser getCurrentUser;

  HomeBloc({
    required this.getBooks,
    required this.getPolycopies,
    required this.getCurrentUser,
  }) : super(HomeInitial()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());

      // Correctly fetch the user data
      final userResult = await getCurrentUser(NoParams());
      User? user; // Declare a nullable User variable

      // Check if the userResult is a success (Right) and extract the user
      userResult.fold(
        (failure) {
          // You could handle the failure here, but for now we'll proceed without a user
          // For now, we'll just set the user to null if there's a failure
        },
        (retrievedUser) {
          user = retrievedUser;
        },
      );

      // Using fake data for books and polycopies
      await Future.delayed(const Duration(milliseconds: 500));

      final List<MaterialEntity> fakeBooks = [
        MaterialEntity(
          id: '1',
          title: 'Book Title 1',
          description: 'Description for book 1',
          imageUrls: [
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg'
          ],
          materialType: 'book',
          priceDzd: 1500.00,
          createdAt: DateTime.now(),
        ),
        MaterialEntity(
          id: '2',
          title: 'Book Title 2',
          description: 'Description for book 2',
          imageUrls: [
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg'
          ],
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
          imageUrls: [
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg'
          ],
          materialType: 'polycopie',
          priceDzd: 500.00,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        MaterialEntity(
          id: '4',
          title: 'Polycopie Title 2',
          description: 'Description for polycopie 2',
          imageUrls: [
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg',
            'https://covers.openlibrary.org/b/id/15094106-L.jpg'
          ],
          materialType: 'polycopie',
          priceDzd: 750.00,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      // Emit the HomeLoaded state with the fake data and the fetched user
      emit(HomeLoaded(books: fakeBooks, polycopies: fakePolycopies, user: user));
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