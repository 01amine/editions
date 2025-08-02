import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:flutter/material.dart';

class EnhancedMaterialListView extends StatelessWidget {
  final List<MaterialEntity> materials;
  final Function(String) onMaterialTap;

  const EnhancedMaterialListView({
    super.key,
    required this.materials,
    required this.onMaterialTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.4,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
        itemCount: materials.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: context.width * 0.04),
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (index * 150)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: AnimatedMaterialCard(
                    material: materials[index],
                    onTap: () => onMaterialTap(materials[index].id),
                    index: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AnimatedMaterialCard extends StatefulWidget {
  final MaterialEntity material;
  final VoidCallback onTap;
  final int index;

  const AnimatedMaterialCard({
    super.key,
    required this.material,
    required this.onTap,
    required this.index,
  });

  @override
  State<AnimatedMaterialCard> createState() => _AnimatedMaterialCardState();
}

class _AnimatedMaterialCardState extends State<AnimatedMaterialCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _offsetAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 16.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.05),
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    if (!_isHovered) {
      setState(() {
        _isHovered = true;
      });
      _hoverController.forward();
    }
  }

  void _onHoverEnd() {
    if (_isHovered) {
      setState(() {
        _isHovered = false;
      });
      _hoverController.reverse();
    }
  }

  void _onTapDown() {
    setState(() {});
    _pressController.forward();
  }

  void _onTapUp() {
    setState(() {});
    _pressController.reverse().then((_) {
      widget.onTap();
    });
  }

  void _onTapCancel() {
    setState(() {});
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverStart(),
      onExit: (_) => _onHoverEnd(),
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _hoverController,
            _pressController,
            _shimmerController,
          ]),
          builder: (context, child) {
            double pressScale = 1.0 - (_pressController.value * 0.03);

            return SlideTransition(
              position: _offsetAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value * pressScale,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: context.width * 0.48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          blurRadius: _elevationAnimation.value,
                          spreadRadius: _elevationAnimation.value * 0.1,
                          offset: Offset(0, _elevationAnimation.value * 0.3),
                        ),
                        if (_isHovered)
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.25),
                            blurRadius: _elevationAnimation.value * 1.5,
                            spreadRadius: _elevationAnimation.value * 0.2,
                            offset: Offset(0, _elevationAnimation.value * 0.5),
                          ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              AppTheme.backgroundColor.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageSection(context),
                            _buildContentSection(context),
                            _buildActionSection(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(context.width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Main image or placeholder
              widget.material.fileUrl?.isNotEmpty == true
                  ? Image.network(
                      widget.material.fileUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildShimmerPlaceholder();
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          _buildStyledPlaceholder(),
                    )
                  : _buildStyledPlaceholder(),

              // Animated overlay with gradient
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    gradient: _isHovered
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppTheme.primaryColor.withOpacity(0.2),
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.05),
                            ],
                          ),
                  ),
                ),
              ),

              // Floating status badge
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.successColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Disponible',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Category indicator
              Positioned(
                bottom: 8,
                left: 8,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? Colors.white.withOpacity(0.95)
                        : Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(),
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getCategoryName(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _shimmerController.value * 2, 0.0),
              end: Alignment(1.0 + _shimmerController.value * 2, 0.0),
              colors: [
                AppTheme.shimmerColor.withOpacity(0.3),
                AppTheme.shimmerColor.withOpacity(0.6),
                AppTheme.shimmerColor.withOpacity(0.3),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image,
              size: 48,
              color: AppTheme.primaryTextColor.withOpacity(0.3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyledPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.15),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _getCategoryIcon(),
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Aperçu',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.width * 0.04,
          context.width * 0.02,
          context.width * 0.04,
          context.width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with enhanced styling
            Text(
              widget.material.title,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTextColor,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // Author or subject info
            if (widget.material.description?.isNotEmpty == true) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  widget.material.description!,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryTextColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.04),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withOpacity(0.9),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: _isHovered ? 8 : 4,
            shadowColor: AppTheme.primaryColor.withOpacity(0.3),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isHovered
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_stories,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: context.width * 0.02),
                      Text(
                        'Ouvrir',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: context.width * 0.02),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(8 * value, 0),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: context.width * 0.02),
                      Text(
                        'Lire plus',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    // You can enhance this based on your material type/category
    if (widget.material.title.toLowerCase().contains('livre')) {
      return Icons.menu_book;
    } else if (widget.material.title.toLowerCase().contains('poly')) {
      return Icons.description;
    } else if (widget.material.title.toLowerCase().contains('cours')) {
      return Icons.school;
    }
    return Icons.library_books;
  }

  String _getCategoryName() {
    // You can enhance this based on your material type/category
    if (widget.material.title.toLowerCase().contains('livre')) {
      return 'Livre';
    } else if (widget.material.title.toLowerCase().contains('poly')) {
      return 'Polycopié';
    } else if (widget.material.title.toLowerCase().contains('cours')) {
      return 'Cours';
    }
    return 'Document';
  }
}
