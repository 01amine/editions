import 'dart:async';

import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editions_lection/features/home/presentation/widgets/module_filter_widget.dart';

import '../../../../modules/module_service.dart';
import '../../domain/entities/material.dart';
import '../widgets/material_grid_item.dart';

class VoirToutScreen extends StatefulWidget {
  final String materialType;

  const VoirToutScreen({
    super.key,
    required this.materialType,
  });

  @override
  State<VoirToutScreen> createState() => _VoirToutScreenState();
}

class _VoirToutScreenState extends State<VoirToutScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  Timer? _debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 500);

  // Module filter state
  List<String> _availableModules = [];
  String? _selectedModule;
  bool _isModulesLoading = true;

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
    _loadUserModules();
  }

  void _startAnimations() async {
    await _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _contentAnimationController.forward();
  }

  Future<void> _loadUserModules() async {
    try {
      setState(() {
        _isModulesLoading = true;
      });

      final homeState = context.read<HomeBloc>().state;
      if (homeState is HomeLoaded && homeState.user != null) {
        final user = homeState.user!;

        // Get modules for user's specialty and year
        final modules = await CurriculumService.getModulesForUser(
          user.specialite,
          user.studyYear,
        );

        setState(() {
          _availableModules = modules;
          _isModulesLoading = false;
        });
      } else {
        // If user data is not available yet, wait for it
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _loadUserModules();
          }
        });
      }
    } catch (e) {
      print('Error loading user modules: $e');
      setState(() {
        _isModulesLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _navigateToMaterialDetails(MaterialEntity material) {
    Navigator.pushNamed(context, '/book_details_screen', arguments: material);
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(_debounceDuration, () {
      if (query.isNotEmpty) {
        context.read<HomeBloc>().add(SearchMaterialsEvent(query: query));
        setState(() {});
      } else {
        context.read<HomeBloc>().add(FetchHomeData());
      }
    });
  }

  void _onModuleFilterChanged(String? module) {
    setState(() {
      _selectedModule = module;
    });
    // Trigger a refresh to apply the filter
    context.read<HomeBloc>().add(FetchHomeData());
  }

  List<MaterialEntity> _getFilteredMaterials() {
    final homeState = context.read<HomeBloc>().state;

    if (homeState is! HomeLoaded) return [];

    List<MaterialEntity> materials;

    // Get materials based on type
    if (widget.materialType == "Livres populaires") {
      materials = homeState.books;
    } else if (widget.materialType == "Polycopiés") {
      materials = homeState.polycopies;
    } else {
      // Fallback: combine all materials
      materials = [...homeState.books, ...homeState.polycopies];
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty && homeState.searchResults != null) {
      final searchResults = homeState.searchResults!;
      // Filter search results by material type
      if (widget.materialType == "Livres populaires") {
        materials = searchResults
            .where((m) => m.materialType.toLowerCase() == 'livre')
            .toList();
      } else if (widget.materialType == "Polycopiés") {
        materials = searchResults
            .where((m) => m.materialType.toLowerCase() == 'polycopie')
            .toList();
      } else {
        materials = searchResults;
      }
    }

    // Apply module filter
    if (_selectedModule != null) {
      final normalizedSelectedModule = _selectedModule!.trim().toLowerCase();
      materials = materials.where((material) {
        final normalizedMaterialModule = material.module.trim().toLowerCase();
        return normalizedMaterialModule == normalizedSelectedModule;
      }).toList();
    }

    return materials;
  }

  String _getScreenTitle() {
    if (widget.materialType == "Livres populaires") {
      return "Tous les livres";
    } else if (widget.materialType == "Polycopiés") {
      return "Tous les polycopiés";
    } else {
      return "Tous les supports";
    }
  }

  IconData _getScreenIcon() {
    if (widget.materialType == "Livres populaires") {
      return Icons.menu_book_rounded;
    } else if (widget.materialType == "Polycopiés") {
      return Icons.description_rounded;
    } else {
      return Icons.library_books_rounded;
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
              await _loadUserModules();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Custom App Bar
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _headerSlideAnimation,
                    child: FadeTransition(
                      opacity: _headerFadeAnimation,
                      child: _buildHeader(),
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _contentSlideAnimation,
                    child: FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.width * 0.05,
                          vertical: context.height * 0.02,
                        ),
                        child: _buildSearchBar(),
                      ),
                    ),
                  ),
                ),

                // Module Filter
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _contentSlideAnimation,
                    child: FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _buildModuleFilter(),
                    ),
                  ),
                ),

                // Filter Status
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _contentSlideAnimation,
                    child: FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _buildFilterStatus(),
                    ),
                  ),
                ),

                // Materials Grid
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _contentSlideAnimation,
                    child: FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: _buildMaterialsContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: context.height * 0.02,
      ),
      child: Row(
        children: [
          // Back Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.primaryTextColor,
                size: 20,
              ),
            ),
          ),

          SizedBox(width: context.width * 0.04),

          // Title Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getScreenIcon(),
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: context.width * 0.03),
                    Expanded(
                      child: Text(
                        _getScreenTitle(),
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.height * 0.005),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    final materials = _getFilteredMaterials();
                    return Text(
                      '${materials.length} support${materials.length > 1 ? 's' : ''} disponible${materials.length > 1 ? 's' : ''}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryTextColor.withOpacity(0.7),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
            hintText: 'Rechercher dans ${widget.materialType.toLowerCase()}...',
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

  Widget _buildModuleFilter() {
    if (_isModulesLoading) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.width * 0.05,
          vertical: 8,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Chargement des modules...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryTextColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ModuleFilterWidget(
      modules: _availableModules,
      selectedModule: _selectedModule,
      onModuleChanged: _onModuleFilterChanged,
      showAllOption: true,
    );
  }

  Widget _buildFilterStatus() {
    if (_selectedModule == null && _searchController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: context.height * 0.01,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_selectedModule != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Module: $_selectedModule',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _onModuleFilterChanged(null),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          if (_searchController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.secondaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                    size: 16,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Recherche: "${_searchController.text}"',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _onSearchChanged('');
                      setState(() {});
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMaterialsContent() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return _buildLoadingState();
        } else if (state is HomeLoaded) {
          final materials = _getFilteredMaterials();
          if (materials.isEmpty) {
            return _buildEmptyState();
          }
          return _buildMaterialsGrid(materials);
        } else if (state is HomeFailure) {
          return _buildErrorState(state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: context.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFiltered =
        _selectedModule != null || _searchController.text.isNotEmpty;

    return Container(
      height: context.height * 0.4,
      margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltered ? Icons.search_off_outlined : _getScreenIcon(),
              size: 64,
              color: AppTheme.primaryTextColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: context.height * 0.02),
          Text(
            isFiltered
                ? 'Aucun résultat trouvé'
                : 'Aucun ${widget.materialType.toLowerCase()} disponible',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.01),
          Text(
            isFiltered
                ? 'Essayez de modifier vos filtres de recherche'
                : 'Les supports seront bientôt disponibles',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryTextColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (isFiltered) ...[
            SizedBox(height: context.height * 0.03),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
                _onModuleFilterChanged(null);
                setState(() {});
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Effacer les filtres'),
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
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(HomeFailure state) {
    return Container(
      height: context.height * 0.4,
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
          ElevatedButton.icon(
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
        ],
      ),
    );
  }

  Widget _buildMaterialsGrid(List<MaterialEntity> materials) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: Column(
        children: List.generate(
          (materials.length / 2).ceil(),
          (rowIndex) {
            final startIndex = rowIndex * 2;
            final endIndex = (startIndex + 2).clamp(0, materials.length);
            final rowMaterials = materials.sublist(startIndex, endIndex);

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (rowIndex * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, animationValue, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - animationValue)),
                  child: Opacity(
                    opacity: animationValue,
                    child: Container(
                      margin: EdgeInsets.only(bottom: context.height * 0.02),
                      child: Row(
                        children: [
                          Expanded(
                            child: MaterialGridItem(
                              material: rowMaterials[0],
                              onTap: () =>
                                  _navigateToMaterialDetails(rowMaterials[0]),
                            ),
                          ),

                          if (rowMaterials.length > 1) ...[
                            SizedBox(width: context.width * 0.04),
                            Expanded(
                              child: MaterialGridItem(
                                material: rowMaterials[1],
                                onTap: () =>
                                    _navigateToMaterialDetails(rowMaterials[1]),
                              ),
                            ),
                          ] else
                            Expanded(child: Container()), // Empty space
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )..add(SizedBox(height: context.height * 0.05)), // Bottom padding
      ),
    );
  }
}
