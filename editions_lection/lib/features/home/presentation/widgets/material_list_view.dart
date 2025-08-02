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
      height: context.height * 0.35,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: materials.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: context.width * 0.04),
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 100)),
            curve: Curves.elasticOut,
            builder: (context, animationValue, child) {
              return Transform.scale(
                scale: animationValue,
                child: AnimatedMaterialCard(
                  material: materials[index],
                  onTap: () => onMaterialTap(materials[index].id),
                  index: index,
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
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: AppTheme.primaryColor,
      end: AppTheme.primaryColor.withOpacity(0.9),
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    setState(() {
      _isHovered = true;
    });
    _hoverController.forward();
  }

  void _onHoverEnd() {
    setState(() {
      _isHovered = false;
    });
    _hoverController.reverse();
  }

  void _onTapDown() {
    _pressController.forward();
  }

  void _onTapUp() {
    _pressController.reverse().then((_) {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverStart(),
      onExit: (_) => _onHoverEnd(),
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: () => _pressController.reverse(),
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _pressController]),
          builder: (context, child) {
            double pressScale = 1.0 - (_pressController.value * 0.05);
            
            return Transform.scale(
              scale: _scaleAnimation.value * pressScale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: context.width * 0.45,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: _elevationAnimation.value,
                      spreadRadius: _elevationAnimation.value * 0.2,
                      offset: Offset(0, _elevationAnimation.value * 0.3),
                    ),
                  ],
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: double.infinity,
              child: widget.material.fileUrl?.isNotEmpty == true
                  ? Image.network(
                      widget.material.fileUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
            // Gradient overlay
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: _isHovered
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.book,
          size: 48,
          color: AppTheme.primaryTextColor.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(context.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.material.title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.material.description?.isNotEmpty == true) ...[
              SizedBox(height: context.height * 0.005),
              Text(
                widget.material.description!,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.width * 0.03),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered 
                ? Colors.white 
                : AppTheme.secondaryColor,
            foregroundColor: _isHovered 
                ? AppTheme.primaryColor 
                : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: _isHovered ? 4 : 2,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lire plus',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isHovered 
                        ? AppTheme.primaryColor 
                        : Colors.white,
                  ),
                ),
                SizedBox(width: context.width * 0.02),
                AnimatedRotation(
                  turns: _isHovered ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: _isHovered 
                        ? AppTheme.primaryColor 
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}