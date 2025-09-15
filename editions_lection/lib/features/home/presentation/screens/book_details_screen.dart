import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/end_points.dart';
import '../../domain/entities/order.dart';
import '../blocs/commands_bloc/commands_bloc.dart';

class BookDetailsScreen extends StatefulWidget {
  final MaterialEntity book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  int _currentImageIndex = 0;
  final bool _isOrderLoading = false;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeControllers() {
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  void _initializeAnimations() {
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

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
  }

  void _startAnimations() async {
    _fadeController.forward();
    await _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // Enhanced Header
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: _buildEnhancedHeader(),
                  ),
                ),
              ),

              // Content with animations
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _contentSlideAnimation,
                  child: FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageGallery(context),
                        _buildBookInfo(context),
                        _buildDescription(context),
                        _buildOrderSection(context),
                        SizedBox(height: context.height * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.05,
        vertical: context.height * 0.02,
      ),
      child: Row(
        children: [
          // Back Button with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppTheme.primaryTextColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      FocusScope.of(context).unfocus();
                    },
                    iconSize: 24,
                  ),
                ),
              );
            },
          ),

          SizedBox(width: context.width * 0.04),

          // Title Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Détails du Livre',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Découvrez les informations complètes',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryTextColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    if (widget.book.imageUrls.isEmpty) {
      return _buildPlaceholderImage(context);
    }
    String baseUrl = EndPoints.baseUrl;
    return Container(
      height: context.height * 0.4,
      margin: EdgeInsets.all(context.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: widget.book.imageUrls.length,
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'book_image_${widget.book.id}_$index',
                  child: Image.network(
                    '$baseUrl/materials/${widget.book.imageUrls[index]}/get_image',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.1),
                              AppTheme.secondaryColor.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor:
                                AppTheme.primaryColor.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor),
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(context),
                  ),
                );
              },
            ),

            // Enhanced Image indicators
            if (widget.book.imageUrls.length > 1)
              Positioned(
                bottom: context.height * 0.02,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.book.imageUrls.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(
                          horizontal: context.width * 0.01),
                      width: _currentImageIndex == index
                          ? context.width * 0.08
                          : context.width * 0.02,
                      height: context.width * 0.02,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _currentImageIndex == index
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

            // Enhanced Navigation arrows
            if (widget.book.imageUrls.length > 1) ...[
              Positioned(
                left: context.width * 0.04,
                top: context.height * 0.18,
                child: GestureDetector(
                  onTap: () {
                    if (_currentImageIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.width * 0.025),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppTheme.primaryColor,
                      size: context.width * 0.05,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: context.width * 0.04,
                top: context.height * 0.18,
                child: GestureDetector(
                  onTap: () {
                    if (_currentImageIndex < widget.book.imageUrls.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.width * 0.025),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.primaryColor,
                      size: context.width * 0.05,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      height: context.height * 0.4,
      margin: EdgeInsets.all(context.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.15),
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(context.width * 0.08),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                _getCategoryIcon(),
                size: context.width * 0.15,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: context.height * 0.02),
            Text(
              'Aucune image disponible',
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.primaryTextColor.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      padding: EdgeInsets.all(context.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with enhanced styling
          Text(
            widget.book.title,
            style: context.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
              height: 1.3,
            ),
          ),
          SizedBox(height: context.height * 0.02),

          // Enhanced Material Type Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.04,
              vertical: context.height * 0.01,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.secondaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(),
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
                SizedBox(width: context.width * 0.02),
                Text(
                  _formatMaterialType(widget.book.materialType),
                  style: context.theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.height * 0.025),

          // Enhanced Price Section
          Container(
            padding: EdgeInsets.all(context.width * 0.04),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.successColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.width * 0.02),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.monetization_on_rounded,
                    color: Colors.white,
                    size: context.width * 0.06,
                  ),
                ),
                SizedBox(width: context.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prix',
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${widget.book.priceDzd.toStringAsFixed(0)} DZD',
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.height * 0.02),

          // Enhanced Creation Date
          Container(
            padding: EdgeInsets.all(context.width * 0.04),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.width * 0.02),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.primaryColor,
                    size: context.width * 0.045,
                  ),
                ),
                SizedBox(width: context.width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date de publication',
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatDate(widget.book.createdAt),
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.primaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (widget.book.description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(context.width * 0.05),
      padding: EdgeInsets.all(context.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.width * 0.025),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: AppTheme.primaryColor,
                  size: context.width * 0.06,
                ),
              ),
              SizedBox(width: context.width * 0.03),
              Text(
                'Description',
                style: context.theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.height * 0.02),
          Container(
            padding: EdgeInsets.all(context.width * 0.04),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.book.description,
              style: context.theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: AppTheme.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      padding: EdgeInsets.all(context.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Order Button
          SizedBox(
            width: double.infinity,
            height: context.height * 0.07,
            child: ElevatedButton.icon(
              onPressed: _isOrderLoading
                  ? null
                  : () => _showEnhancedOrderDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _isOrderLoading
                  ? SizedBox(
                      width: context.width * 0.05,
                      height: context.width * 0.05,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      Icons.shopping_cart_rounded,
                      size: context.width * 0.06,
                    ),
              label: Text(
                _isOrderLoading
                    ? 'Commande en cours...'
                    : 'Commander maintenant',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEnhancedOrderDialog(BuildContext context) {
    // Initialize state variables
    DeliveryType selectedDeliveryType = DeliveryType.pickup;
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                constraints: BoxConstraints(
                  maxHeight: context.height * 0.8,
                  maxWidth: context.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(context.width * 0.06),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header with icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor.withOpacity(0.2),
                                    AppTheme.secondaryColor.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                Icons.shopping_cart_rounded,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ),

                            SizedBox(height: context.height * 0.02),

                            // Title
                            Text(
                              'Confirmer la commande',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: context.height * 0.02),

                            // Book Info Container
                            Container(
                              padding: EdgeInsets.all(context.width * 0.04),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.backgroundColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            context.width * 0.02),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          _getCategoryIcon(),
                                          color: AppTheme.primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(width: context.width * 0.03),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.book.title,
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodyLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppTheme.primaryTextColor,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              _formatMaterialType(
                                                  widget.book.materialType),
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall
                                                  ?.copyWith(
                                                color:
                                                    AppTheme.secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: context.height * 0.015),
                                  Divider(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.2),
                                    thickness: 1,
                                  ),
                                  SizedBox(height: context.height * 0.015),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Prix total:',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primaryTextColor,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: context.width * 0.03,
                                          vertical: context.height * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.successColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${widget.book.priceDzd.toStringAsFixed(0)} DA',
                                          style: AppTheme.lightTheme.textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                            color: AppTheme.successColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: context.height * 0.03),

                            // Delivery Type Selection
                            Container(
                              padding: EdgeInsets.all(context.width * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type de livraison',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                                  SizedBox(height: context.height * 0.015),

                                  // Pickup Option
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDeliveryType =
                                            DeliveryType.pickup;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(context.width * 0.03),
                                      decoration: BoxDecoration(
                                        color: selectedDeliveryType ==
                                                DeliveryType.pickup
                                            ? AppTheme.primaryColor
                                                .withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: selectedDeliveryType ==
                                                  DeliveryType.pickup
                                              ? AppTheme.primaryColor
                                              : Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<DeliveryType>(
                                            value: DeliveryType.pickup,
                                            groupValue: selectedDeliveryType,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDeliveryType = value!;
                                              });
                                            },
                                            activeColor: AppTheme.primaryColor,
                                          ),
                                          Icon(
                                            Icons.store_rounded,
                                            color: AppTheme.primaryColor,
                                            size: 20,
                                          ),
                                          SizedBox(width: context.width * 0.02),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Retrait en magasin',
                                                  style: AppTheme.lightTheme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme
                                                        .primaryTextColor,
                                                  ),
                                                ),
                                                Text(
                                                  'Gratuit - Retrait dans nos locaux',
                                                  style: AppTheme.lightTheme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppTheme
                                                        .secondaryTextColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: context.height * 0.01),

                                  // Delivery Option
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedDeliveryType =
                                            DeliveryType.delivery;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(context.width * 0.03),
                                      decoration: BoxDecoration(
                                        color: selectedDeliveryType ==
                                                DeliveryType.delivery
                                            ? AppTheme.primaryColor
                                                .withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: selectedDeliveryType ==
                                                  DeliveryType.delivery
                                              ? AppTheme.primaryColor
                                              : Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<DeliveryType>(
                                            value: DeliveryType.delivery,
                                            groupValue: selectedDeliveryType,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDeliveryType = value!;
                                              });
                                            },
                                            activeColor: AppTheme.primaryColor,
                                          ),
                                          Icon(
                                            Icons.local_shipping_rounded,
                                            color: AppTheme.primaryColor,
                                            size: 20,
                                          ),
                                          SizedBox(width: context.width * 0.02),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Livraison à domicile',
                                                  style: AppTheme.lightTheme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme
                                                        .primaryTextColor,
                                                  ),
                                                ),
                                                Text(
                                                  'Livraison à votre adresse',
                                                  style: AppTheme.lightTheme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppTheme
                                                        .secondaryTextColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delivery Details (only show if delivery is selected)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height:
                                  selectedDeliveryType == DeliveryType.delivery
                                      ? null
                                      : 0,
                              child: selectedDeliveryType ==
                                      DeliveryType.delivery
                                  ? Column(
                                      children: [
                                        SizedBox(height: context.height * 0.02),
                                        Container(
                                          padding: EdgeInsets.all(
                                              context.width * 0.04),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Informations de livraison',
                                                style: AppTheme.lightTheme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppTheme.primaryTextColor,
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      context.height * 0.015),

                                              // Address Field
                                              TextField(
                                                controller: addressController,
                                                maxLines: 2,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Adresse de livraison *',
                                                  hintText:
                                                      'Entrez votre adresse complète',
                                                  prefixIcon: Icon(
                                                    Icons.location_on_rounded,
                                                    color:
                                                        AppTheme.primaryColor,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: AppTheme
                                                          .primaryColor
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: AppTheme
                                                          .primaryColor
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppTheme.primaryColor,
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal:
                                                        context.width * 0.04,
                                                    vertical:
                                                        context.height * 0.015,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                  height:
                                                      context.height * 0.015),

                                              // Phone Field
                                              TextField(
                                                controller: phoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Numéro de téléphone *',
                                                  hintText: 'Ex: 0555 123 456',
                                                  prefixIcon: Icon(
                                                    Icons.phone_rounded,
                                                    color:
                                                        AppTheme.primaryColor,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: AppTheme
                                                          .primaryColor
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: AppTheme
                                                          .primaryColor
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppTheme.primaryColor,
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal:
                                                        context.width * 0.04,
                                                    vertical:
                                                        context.height * 0.015,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            SizedBox(height: context.height * 0.03),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FocusScope.of(context).unfocus();
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: context.height * 0.015,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Annuler',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: context.width * 0.04),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Validate delivery details if delivery is selected
                                      if (selectedDeliveryType ==
                                          DeliveryType.delivery) {
                                        if (addressController.text
                                                .trim()
                                                .isEmpty ||
                                            phoneController.text
                                                .trim()
                                                .isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Veuillez remplir tous les champs obligatoires',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              margin: EdgeInsets.all(
                                                  context.width * 0.04),
                                            ),
                                          );
                                          return;
                                        }
                                      }

                                      Navigator.of(context).pop();

                                      // Create order with delivery details
                                      context.read<CommandsBloc>().add(
                                            CreateOrderEvent(
                                              orders: [
                                                OrderCreateEntity(
                                                  materialId: widget.book.id,
                                                  quantity: 1,
                                                  deliveryType:
                                                      selectedDeliveryType,
                                                  deliveryAddress:
                                                      selectedDeliveryType ==
                                                              DeliveryType
                                                                  .delivery
                                                          ? addressController
                                                              .text
                                                              .trim()
                                                          : null,
                                                  deliveryPhone:
                                                      selectedDeliveryType ==
                                                              DeliveryType
                                                                  .delivery
                                                          ? phoneController.text
                                                              .trim()
                                                          : null,
                                                ),
                                              ],
                                              deliveryType:
                                                  selectedDeliveryType,
                                              deliveryAddress:
                                                  selectedDeliveryType ==
                                                          DeliveryType.delivery
                                                      ? addressController.text
                                                          .trim()
                                                      : null,
                                              deliveryPhone:
                                                  selectedDeliveryType ==
                                                          DeliveryType.delivery
                                                      ? phoneController.text
                                                          .trim()
                                                      : null,
                                            ),
                                          );

                                      FocusScope.of(context).unfocus();

                                      // Show success message
                                      String deliveryMessage = selectedDeliveryType ==
                                              DeliveryType.pickup
                                          ? 'Commande confirmée pour retrait en magasin!'
                                          : 'Commande confirmée pour livraison!';

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  deliveryMessage,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              AppTheme.successColor,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin: EdgeInsets.all(
                                              context.width * 0.04),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: context.height * 0.015,
                                      ),
                                      elevation: 4,
                                      shadowColor: AppTheme.primaryColor
                                          .withOpacity(0.4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: context.width * 0.05,
                                        ),
                                        SizedBox(width: context.width * 0.02),
                                        Text(
                                          'Confirmer',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon() {
    switch (widget.book.materialType.toLowerCase()) {
      case 'livre':
      case 'book':
        return Icons.menu_book_rounded;
      case 'magazine':
        return Icons.newspaper_rounded;
      case 'manuel':
      case 'textbook':
        return Icons.school_rounded;
      case 'cahier':
      case 'notebook':
        return Icons.note_rounded;
      case 'guide':
        return Icons.map_rounded;
      default:
        return Icons.library_books_rounded;
    }
  }

  String _formatMaterialType(String type) {
    switch (type.toLowerCase()) {
      case 'livre':
        return 'Livre';
      case 'magazine':
        return 'Magazine';
      case 'manuel':
        return 'Manuel scolaire';
      case 'cahier':
        return 'Cahier d\'exercices';
      case 'guide':
        return 'Guide';
      default:
        return StringExtension(type).capitalize();
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
