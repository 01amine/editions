import 'package:editions_lection/features/home/presentation/screens/book_details_screen.dart';
import 'package:editions_lection/features/home/presentation/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/home/domain/entities/material.dart';
import 'features/home/presentation/blocs/commands_bloc/commands_bloc.dart';
import 'features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'features/home/presentation/screens/commands_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Editions Lection',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const SplashScreen());
            case '/onboarding':
              return MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => di.sl<OnboardingBloc>(),
                  child: const OnboardingScreen(),
                ),
              );
            case '/login':
              return MaterialPageRoute(
                  builder: (context) => const LoginScreen());
            case '/signup':
              return MaterialPageRoute(
                  builder: (context) => const SignupScreen());
            case '/home':
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
            case '/book_details_screen':
              final Object? book = settings.arguments;
              return MaterialPageRoute(
                builder: (context) =>
                    BookDetailsScreen(book: book as MaterialEntity),
              );
            case '/commands':
              return MaterialPageRoute(
                builder: (context) => const CommandsScreen(),
              );
            case '/notification':
              return MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              );
            case '/forgot_password':
              return MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: Text('Error: Page not found!'),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
