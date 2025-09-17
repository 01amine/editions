import 'package:editions_lection/features/home/presentation/screens/book_details_screen.dart';
import 'package:editions_lection/features/home/presentation/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/home/domain/entities/material.dart';
import 'features/home/presentation/blocs/commands_bloc/commands_bloc.dart';
import 'features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'features/home/presentation/blocs/notifications/notification_bloc.dart';
import 'features/home/presentation/screens/commands_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/voir_tout_screen.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await dotenv.load(fileName: ".env");
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<SplashBloc>()..add(const InitializeApp()),
        ),
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<OnboardingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<HomeBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<CommandsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<NotificationBloc>(),
        ),
      ],
      child: _buildApp(),
    );
  }

  Widget _buildApp() {
    // Determine initial route based on platform
    Widget initialScreen;
    if (kIsWeb) {
      initialScreen = const LoginScreen();
    } else {
      initialScreen = const SplashScreen();
    }

    // Use CupertinoApp for iOS, MaterialApp for Android and Web
    if (!kIsWeb && Platform.isIOS) {
      return MaterialApp(
        home: CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: 'Editions Lection',
          theme: const CupertinoThemeData(
            brightness: Brightness.dark,
          ),
          home: initialScreen,
          onGenerateRoute: _generateRoute,
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Editions Lection',
        theme: AppTheme.darkTheme,
        home: initialScreen,
        onGenerateRoute: _generateRoute,
      );
    }
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const SplashScreen());
      case '/onboarding':
        return _createRoute(
          BlocProvider(
            create: (_) => di.sl<OnboardingBloc>(),
            child: const OnboardingScreen(),
          ),
        );
      case '/login':
        return _createRoute(const LoginScreen());
      case '/signup':
        return _createRoute(const SignupScreen());
      case '/home':
        return _createRoute(const HomeScreen());
      case '/book_details_screen':
        final Object? book = settings.arguments;
        return _createRoute(
          BookDetailsScreen(book: book as MaterialEntity),
        );
      case '/commands':
        return _createRoute(const CommandsScreen());
      case '/notification':
        return _createRoute(const NotificationsScreen());
      case '/forgot_password':
        return _createRoute(const ForgotPasswordScreen());
      case '/profile':
        return _createRoute(const ProfileScreen());
      case '/voir-tout':
        final materialType = settings.arguments as String;
        return _createRoute(
          VoirToutScreen(materialType: materialType),
        );
      default:
        return _createRoute(
          const Scaffold(
            body: Center(
              child: Text('Error: Page not found!'),
            ),
          ),
        );
    }
  }

  Route<dynamic> _createRoute(Widget screen) {
    // Use CupertinoPageRoute for iOS, MaterialPageRoute for others
    if (!kIsWeb && Platform.isIOS) {
      return CupertinoPageRoute(builder: (context) => screen);
    } else {
      return MaterialPageRoute(builder: (context) => screen);
    }
  }
}