import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/constants/end_points.dart';
import '../core/network/network_info.dart';
import '../features/auth/data/datasource/local_data.dart';
import '../features/auth/data/datasource/local_data_impl.dart';
import '../features/auth/data/datasource/remote_data.dart';
import '../features/auth/data/datasource/remote_data_impl.dart';
import '../features/auth/data/repositories/authrepositoryimpl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/clear_token.dart';
import '../features/auth/domain/usecases/foget_password.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/domain/usecases/get_token.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/reset_password.dart';
import '../features/auth/domain/usecases/save_token.dart';
import '../features/auth/domain/usecases/signup_user.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/data/datasource/notifications_remote_data_souce.dart';
import '../features/home/data/datasource/remote_data.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/data/repositories/notifications_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/repositories/notification_repository.dart';
import '../features/home/domain/usecases/create_order.dart';
import '../features/home/domain/usecases/get_books.dart';
import '../features/home/domain/usecases/get_notifications.dart';
import '../features/home/domain/usecases/get_orders.dart';
import '../features/home/domain/usecases/get_polycopies.dart';
import '../features/home/domain/usecases/search_materials.dart';
import '../features/home/presentation/blocs/home_bloc/home_bloc.dart';
import '../features/home/presentation/blocs/notifications/notification_bloc.dart';
import '../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../features/onboarding/domain/usecases/get_onboarding_seen.dart';
import '../features/onboarding/domain/usecases/save_onboarding_seen.dart';
import '../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../features/splash/domain/is_user_loged_in.dart';
import '../features/splash/presentation/bloc/splash_bloc.dart';
import '../features/home/presentation/blocs/commands_bloc/commands_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await sl.reset();

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl<Connectivity>(),
      connectionChecker: sl<InternetConnection>(),
    ),
  );

  // Auth Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
        client: sl<http.Client>(), baseUrl: EndPoints.baseUrl),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Auth Use Cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl<AuthRepository>()));
  sl.registerLazySingleton<SignupUser>(() => SignupUser(sl<AuthRepository>()));
  sl.registerLazySingleton<SaveToken>(() => SaveToken(sl<AuthRepository>()));
  sl.registerLazySingleton<GetToken>(() => GetToken(sl<AuthRepository>()));
  sl.registerLazySingleton<ClearToken>(() => ClearToken(sl<AuthRepository>()));
  sl.registerLazySingleton<GetCurrentUser>(
      () => GetCurrentUser(sl<AuthRepository>()));
  sl.registerLazySingleton<ForgetPasswordUser>(
      () => ForgetPasswordUser(sl<AuthRepository>()));
  sl.registerLazySingleton<ResetPasswordUser>(
      () => ResetPasswordUser(sl<AuthRepository>()));

  // Onboarding Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl<SharedPreferences>()),
  );

  // Onboarding Use Cases
  sl.registerLazySingleton<GetOnboardingSeen>(
      () => GetOnboardingSeen(sl<OnboardingRepository>()));
  sl.registerLazySingleton<SaveOnboardingSeen>(
      () => SaveOnboardingSeen(sl<OnboardingRepository>()));

  // Splash Use Cases
  sl.registerLazySingleton<IsUserLoggedIn>(
    () => IsUserLoggedIn(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(() => CreateOrder(repository: sl()));
  sl.registerLazySingleton(() => GetOrders(repository: sl()));

  // BLoCs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUser: sl<LoginUser>(),
      signupUser: sl<SignupUser>(),
      saveToken: sl<SaveToken>(),
      clearToken: sl<ClearToken>(),
      getCurrentUser: sl<GetCurrentUser>(),
      forgetPasswordUser: sl<ForgetPasswordUser>(),
      resetPasswordUser: sl<ResetPasswordUser>(),
    ),
  );

  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      getSeen: sl<GetOnboardingSeen>(),
      saveSeen: sl<SaveOnboardingSeen>(),
    ),
  );

  sl.registerFactory<SplashBloc>(
    () => SplashBloc(
      getOnboardingSeen: sl<GetOnboardingSeen>(),
      isUserLoggedIn: sl<IsUserLoggedIn>(),
    ),
  );

  // BLoC
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getBooks: sl<GetBooks>(),
      getPolycopies: sl<GetPolycopies>(),
      getCurrentUser: sl<GetCurrentUser>(),
      searchMaterials: sl<SearchMaterials>(),
    ),
  );
  sl.registerFactory(() => CommandsBloc(
        createOrder: sl(),
        getOrders: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetBooks(sl()));
  sl.registerLazySingleton(() => GetPolycopies(sl()));
  sl.registerLazySingleton(() => SearchMaterials(sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      sl<NetworkInfo>(),
      sl<AuthLocalDataSource>(),
      remoteDataSource: sl<HomeRemoteDataSource>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      client: sl<http.Client>(),
      baseUrl: EndPoints.baseUrl,
    ),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      client: sl<http.Client>(),
      baseUrl: EndPoints.baseUrl,
    ),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl<NotificationRepository>()));
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
    ),
  );
}
