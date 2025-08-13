import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/end_points.dart';

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
  late Animation<double> _fadeAnimation;
  int _currentImageIndex = 0;
  bool _isOrderLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(context.width * 0.02),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _buildImageGallery(context),
                  _buildBookInfo(context),
                  _buildDescription(context),
                  _buildOrderSection(context),
                  SizedBox(height: context.height * 0.02),
                ],
              ),
            ),
          ],
        ),
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.05),
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

            // Image indicators
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
                            ? AppTheme.primaryColor
                            : AppTheme.primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

            // Navigation arrows
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
                    padding: EdgeInsets.all(context.width * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
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
                    padding: EdgeInsets.all(context.width * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
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
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.primaryColor.withOpacity(0.05),
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
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
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
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryTextColor.withOpacity(0.7),
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
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.book.title,
            style: context.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
          SizedBox(height: context.height * 0.015),

          // Material Type Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.04,
              vertical: context.height * 0.008,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _formatMaterialType(widget.book.materialType),
              style: context.theme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: context.height * 0.02),

          // Price
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: AppTheme.successColor,
                size: context.width * 0.06,
              ),
              SizedBox(width: context.width * 0.02),
              Text(
                '${widget.book.priceDzd.toStringAsFixed(0)} DZD',
                style: context.theme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: context.height * 0.015),

          // Creation Date
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppTheme.secondaryTextColor,
                size: context.width * 0.045,
              ),
              SizedBox(width: context.width * 0.02),
              Text(
                'Publié le ${_formatDate(widget.book.createdAt)}',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
          // Removed the image count section as requested
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
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: AppTheme.primaryColor,
                size: context.width * 0.06,
              ),
              SizedBox(width: context.width * 0.02),
              Text(
                'Description',
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: context.height * 0.015),
          Text(
            widget.book.description,
            style: context.theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: AppTheme.primaryTextColor,
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
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Button
          SizedBox(
            width: double.infinity,
            height: context.height * 0.06,
            child: ElevatedButton.icon(
              onPressed: _isOrderLoading ? null : () => _handleOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                      Icons.shopping_cart,
                      size: context.width * 0.05,
                    ),
              label: Text(
                _isOrderLoading
                    ? 'Commande en cours...'
                    : 'Commander maintenant',
                style: context.theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Removed the contact options (Appeler and Message buttons) as requested
        ],
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (widget.book.materialType.toLowerCase()) {
      case 'livre':
      case 'book':
        return Icons.menu_book;
      case 'magazine':
        return Icons.newspaper;
      case 'manuel':
      case 'textbook':
        return Icons.school;
      case 'cahier':
      case 'notebook':
        return Icons.note;
      case 'guide':
        return Icons.map;
      default:
        return Icons.library_books;
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

  void _handleOrder(BuildContext context) async {
    setState(() {
      _isOrderLoading = true;
    });

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isOrderLoading = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppTheme.surfaceColor,
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
                size: context.width * 0.06,
              ),
              SizedBox(width: context.width * 0.02),
              Text(
                'Commande confirmée',
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
            ],
          ),
          content: Text(
            'Votre commande pour "${widget.book.title}" a été enregistrée. Nous vous contacterons bientôt.',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryTextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
              child: Text(
                'OK',
                style: context.theme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

// Extension for String capitalization (if not already in your extensions)
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
