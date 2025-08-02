import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editions_lection/features/home/presentation/widgets/material_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchHomeData());
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else {
      return 'Bonsoir';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_getGreeting()} User_name', // TODO: Get user name from AuthBloc
                    style: AppTheme.lightTheme.textTheme.headlineMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications,
                            color: AppTheme.primaryTextColor),
                        onPressed: () {
                          // TODO: navigation to notifications screen
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.book, color: AppTheme.primaryTextColor),
                        onPressed: () {
                          // TODO: navigation to command screen
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.height * 0.02),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un support, un auteur...',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: AppTheme.primaryTextColor, width: 1),
                  ),
                  prefixIcon: Icon(Icons.search, color: AppTheme.primaryTextColor),
                ),
              ),
              SizedBox(height: context.height * 0.02),
              Text("Livres populaires",
                  style: AppTheme.lightTheme.textTheme.headlineMedium),
              SizedBox(height: context.height * 0.02),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    return MaterialListView(materials: state.books);
                  } else if (state is HomeFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: context.height * 0.02),
              Text("Polycopies",
                  style: AppTheme.lightTheme.textTheme.headlineMedium),
              SizedBox(height: context.height * 0.02),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    return MaterialListView(materials: state.polycopies);
                  } else if (state is HomeFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}