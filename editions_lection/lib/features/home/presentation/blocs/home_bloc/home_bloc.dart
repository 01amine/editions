import 'package:bloc/bloc.dart';
import 'package:editions_lection/core/errors/failure.dart';
import 'package:editions_lection/core/usecase/usecase.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:editions_lection/features/home/domain/usecases/get_books.dart';
import 'package:editions_lection/features/home/domain/usecases/get_polycopies.dart';
import 'package:equatable/equatable.dart';

import '../../../../auth/domain/entities/user.dart';
import '../../../../auth/domain/usecases/get_current_user.dart';
import '../../../domain/usecases/search_materials.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBooks getBooks;
  final GetPolycopies getPolycopies;
  final GetCurrentUser getCurrentUser;
  final SearchMaterials searchMaterials;

  HomeBloc({
    required this.getBooks,
    required this.getPolycopies,
    required this.getCurrentUser,
    required this.searchMaterials,
  }) : super(HomeInitial()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());

      final userResult = await getCurrentUser(NoParams());
      User? user;
      userResult.fold(
        (failure) {},
        (retrievedUser) {
          user = retrievedUser;
        },
      );

      final booksResult = await getBooks(NoParams());
      final polycopiesResult = await getPolycopies(NoParams());

      booksResult.fold(
        (failure) {
          emit(HomeFailure(message: _mapFailureToMessage(failure)));
        },
        (books) {
          polycopiesResult.fold(
            (failure) {
              emit(HomeFailure(message: _mapFailureToMessage(failure)));
            },
            (polycopies) {
              emit(
                HomeLoaded(books: books, polycopies: polycopies, user: user),
              );
            },
          );
        },
      );
    });

    on<SearchMaterialsEvent>((event, emit) async {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final searchResult = await searchMaterials(event.query);
        searchResult.fold(
          (failure) {
            emit(HomeFailure(message: _mapFailureToMessage(failure)));
          },
          (results) {
            emit(currentState.copyWith(searchResults: results));
          },
        );
      }
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
