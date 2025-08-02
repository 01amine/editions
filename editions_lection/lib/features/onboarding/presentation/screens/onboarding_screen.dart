import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/images.dart';
import '../../domain/entities/onboarding_page.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late final List<OnboardingPage> _pages;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _iconController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Pre-cache images for instant loading
    _precacheImages();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    _pages = [
      OnboardingPage(
        title: "Votre Bibliothèque Médicale",
        description:
            "Accédez à une vaste collection de livres médicaux, manuels universitaires et ressources académiques spécialement sélectionnées pour les étudiants en médecine.",
        assetPath: AppImages.onboarding1,
      ),
      OnboardingPage(
        title: "Polycopiés & Supports de Cours",
        description:
            "Commandez vos polycopiés, notes de cours et supports pédagogiques directement depuis l'application. Impression de qualité professionnelle garantie.",
        assetPath: AppImages.onboarding2,
      ),
      OnboardingPage(
        title: "Préparation aux Examens",
        description:
            "QCM, annales d'examens, guides de révision et ouvrages de préparation aux concours. Tout ce dont vous avez besoin pour réussir vos études médicales.",
        assetPath: AppImages.onboarding3,
      ),
    ];

    // Start initial animations
    _fadeController.forward();
    _slideController.forward();
    _iconController.forward();
  }

  // Pre-cache all images for instant loading
  void _precacheImages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final imagePaths = [
        AppImages.onboarding1,
        AppImages.onboarding2,
        AppImages.onboarding3,
      ];

      for (String imagePath in imagePaths) {
        precacheImage(AssetImage(imagePath), context);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.read<OnboardingBloc>().add(CompleteOnboarding());
    }
  }

  void _onSkip() {
    context.read<OnboardingBloc>().add(CompleteOnboarding());
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _slideController.reset();
    _iconController.reset();
    _slideController.forward();
    _iconController.forward();
  }

  Color _getPageAccentColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF2E7D32); // Deep green
      case 1:
        return const Color(0xFF1976D2); // Blue
      case 2:
        return const Color(0xFFD32F2F); // Red
      default:
        return const Color(0xFF2E7D32);
    }
  }

  List<String> _getPageFeatures(int index) {
    switch (index) {
      case 0:
        return [
          '📚 Manuels de médecine',
          '🔬 Ouvrages spécialisés',
          '📖 Références académiques'
        ];
      case 1:
        return [
          '📄 Polycopiés de cours',
          '✏️ Notes personnalisées',
          '🖨️ Impression haute qualité'
        ];
      case 2:
        return [
          '❓ QCM par spécialité',
          '📋 Annales d\'examens',
          '🎯 Guides de révision'
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double containerHeight = size.height * 0.55;
    final double imageAreaHeight =
        size.height - containerHeight + 32; // +32 for overlap

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient - Full screen
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF8F9FA),
                      const Color(0xFFFFFFFF),
                      _getPageAccentColor(_currentIndex).withOpacity(0.05),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Images - Top area with overlap
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: imageAreaHeight,
              child: SafeArea(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _iconController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _iconScaleAnimation.value,
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.asset(
                              _pages[index].assetPath,
                              fit: BoxFit.cover, // Fill the entire area
                              width: double.infinity,
                              height: double.infinity,
                              // Add gapless playback for smoother transitions
                              gaplessPlayback: true,
                              // Add error handling
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: _getPageAccentColor(index)
                                      .withOpacity(0.1),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: _getPageAccentColor(index),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Content Container - Bottom part
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: containerHeight,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Handle bar
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Content Area
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(32, 32, 32, 16),
                              child: AnimatedBuilder(
                                animation: _slideAnimation,
                                builder: (context, child) {
                                  return SlideTransition(
                                    position: _slideAnimation,
                                    child: FadeTransition(
                                      opacity: _slideController,
                                      child: SingleChildScrollView(
                                        child: _buildPageContent(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Navigation Area
                          Container(
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 40),
                            child: Column(
                              children: [
                                // Page Indicators
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _pages.length,
                                    (index) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      width: _currentIndex == index ? 32 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: _currentIndex == index
                                            ? const Color(0xFF2E7D32)
                                            : const Color(0xFFE0E0E0),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // Navigation Buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSkipButton(),
                                    _buildNextButton(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    final page = _pages[_currentIndex];
    final features = _getPageFeatures(_currentIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          page.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C2C2C),
                height: 1.2,
              ),
        ),

        const SizedBox(height: 20),

        // Description
        Text(
          page.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF5A5A5A),
                height: 1.6,
                fontSize: 16,
              ),
        ),

        const SizedBox(height: 28),

        // Features list
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _getPageAccentColor(_currentIndex),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF2C2C2C),
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _onSkip,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF9E9E9E),
      ),
      child: Text(
        'Passer',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9E9E9E),
            ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastPage = _currentIndex == _pages.length - 1;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32),
            const Color(0xFF4CAF50),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: _onNext,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastPage ? 'Commencer' : 'Suivant',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              isLastPage ? Icons.arrow_forward : Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
