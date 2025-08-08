import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editions_lection/features/home/presentation/widgets/cards_list.dart';

import '../../domain/entities/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Setup animations
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.elasticOut,
    ));

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.elasticOut,
    ));

    _searchController = TextEditingController();

    // Listen to search focus changes
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    // Fetch data and start animations
    context.read<HomeBloc>().add(FetchHomeData());
    _startAnimations();
  }

  void _startAnimations() async {
    await _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 18) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  String _getUserName() {
    // TODO: Get actual user name from AuthBloc
    // For now, return a placeholder that could be replaced with actual auth data
    return 'Utilisateur';
  }

  int _getNotificationCount() {
    // TODO: Get actual notification count from NotificationBloc
    return 3; // Placeholder value
  }

  int _getCommandCount() {
    // TODO: Get actual command count from CommandBloc
    return 2; // Placeholder value
  }

  void _navigateToNotifications() {
    // TODO: Implement navigation to notifications screen
    Navigator.pushNamed(context, '/notifications');
  }

  void _navigateToCommands() {
    // TODO: Implement navigation to commands/orders screen
    Navigator.pushNamed(context, '/commands');
  }

  void _navigateToMaterialDetails(MaterialEntity material) {
    // TODO: Implement navigation to material details screen
    Navigator.pushNamed(context, '/material-details', arguments: material.id);
  }

  void _onSearchChanged(String query) {
    // TODO: Implement search functionality
    // You might want to add a search event to your bloc
    if (query.isNotEmpty) {
      // context.read<HomeBloc>().add(SearchMaterials(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(FetchHomeData());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.height * 0.02),

                    // Animated Header
                    SlideTransition(
                      position: _headerSlideAnimation,
                      child: FadeTransition(
                        opacity: _headerFadeAnimation,
                        child: _buildHeader(),
                      ),
                    ),

                    SizedBox(height: context.height * 0.03),

                    // Animated Search Bar
                    SlideTransition(
                      position: _contentSlideAnimation,
                      child: FadeTransition(
                        opacity: _contentFadeAnimation,
                        child: _buildSearchBar(),
                      ),
                    ),

                    SizedBox(height: context.height * 0.03),

                    // Animated Content Sections
                    SlideTransition(
                      position: _contentSlideAnimation,
                      child: FadeTransition(
                        opacity: _contentFadeAnimation,
                        child: _buildContentSections(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()},',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.primaryTextColor.withOpacity(0.7),
                ),
              ),
              Text(
                _getUserName(),
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildAnimatedIconButtonWithBadge(
              icon: Icons.notifications_outlined,
              onPressed: _navigateToNotifications,
              delay: const Duration(milliseconds: 600),
              badgeCount: _getNotificationCount(),
            ),
            SizedBox(width: context.width * 0.02),
            _buildAnimatedIconButtonWithBadge(
              icon: Icons.book_outlined,
              onPressed: _navigateToCommands,
              delay: const Duration(milliseconds: 700),
              badgeCount: _getCommandCount(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedIconButtonWithBadge({
    required IconData icon,
    required VoidCallback onPressed,
    required Duration delay,
    required int badgeCount,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(icon, color: AppTheme.primaryTextColor),
                  onPressed: onPressed,
                  iconSize: 24,
                  splashRadius: 20,
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.backgroundColor,
                        width: 2,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      badgeCount > 99 ? '99+' : badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
          if (_isSearchFocused)
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                _isSearchFocused ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _onSearchChanged,
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Rechercher un support, un auteur...',
            hintStyle: TextStyle(
              color: AppTheme.primaryTextColor.withOpacity(0.5),
              fontSize: 16,
            ),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.search_rounded,
                  color: _isSearchFocused
                      ? AppTheme.primaryColor
                      : AppTheme.primaryTextColor.withOpacity(0.5),
                  size: 24,
                ),
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppTheme.primaryTextColor.withOpacity(0.5),
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                        setState(() {});
                      },
                      splashRadius: 16,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSections() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return _buildLoadingState();
        } else if (state is HomeLoaded) {
          return _buildLoadedState(state);
        } else if (state is HomeFailure) {
          return _buildErrorState(state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        SizedBox(height: context.height * 0.1),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: CircularProgressIndicator(
                value: value,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                strokeWidth: 3,
              ),
            );
          },
        ),
        SizedBox(height: context.height * 0.02),
        Text(
          'Chargement des supports...',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryTextColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionWithAnimation(
          title: "Livres populaires",
          materials: state.books,
          delay: const Duration(milliseconds: 200),
        ),
        SizedBox(height: context.height * 0.03),
        _buildSectionWithAnimation(
          title: "Polycopiés",
          materials: state.polycopies,
          delay: const Duration(milliseconds: 400),
        ),
        SizedBox(height: context.height * 0.05),
      ],
    );
  }

  Widget _buildSectionWithAnimation({
    required String title,
    required List<MaterialEntity> materials,
    required Duration delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (materials.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to see all materials of this type
                          Navigator.pushNamed(context, '/materials',
                              arguments: title);
                        },
                        child: Text(
                          'Voir tout',
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: context.height * 0.015),
                if (materials.isEmpty)
                  _buildEmptyState(title)
                else
                  CardsList(
                    materials: materials,
                    onMaterialTap: _navigateToMaterialDetails,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String section) {
    return Container(
      height: context.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 48,
            color: AppTheme.primaryTextColor.withOpacity(0.5),
          ),
          SizedBox(height: context.height * 0.01),
          Text(
            'Aucun ${section.toLowerCase()} disponible',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(HomeFailure state) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.bounceOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.withOpacity(0.7),
                ),
              );
            },
          ),
          SizedBox(height: context.height * 0.02),
          Text(
            'Oops! Une erreur s\'est produite',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.height * 0.01),
          Text(
            state.message,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryTextColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.03),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<HomeBloc>().add(FetchHomeData());
                _startAnimations();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
