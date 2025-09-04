import 'package:editions_lection/core/constants/end_points.dart';
import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order.dart';
import '../blocs/commands_bloc/commands_bloc.dart';

class CardsList extends StatelessWidget {
  final List<MaterialEntity> materials;
  final Function(MaterialEntity) onMaterialTap;

  const CardsList({
    super.key,
    required this.materials,
    required this.onMaterialTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.45,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
        itemCount: materials.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: context.width * 0.03),
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
                  child: BookCard(
                    material: materials[index],
                    onTap: () => onMaterialTap(materials[index]),
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

class BookCard extends StatefulWidget {
  final MaterialEntity material;
  final VoidCallback onTap;
  final int index;

  const BookCard({
    super.key,
    required this.material,
    required this.onTap,
    required this.index,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pressController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _pressController.forward();
  }

  void _onTapUp() {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          double pressScale = 1.0 - (_pressController.value * 0.03);

          return Transform.scale(
            scale: pressScale,
            child: Container(
              width: context.width * 0.5,
              height: context.height * 0.42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
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
          );
        },
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    String baseUrl = EndPoints.baseUrl;
    return Container(
      height: context.height * 0.22,
      width: double.infinity,
      margin: EdgeInsets.all(context.width * 0.025),
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
            if (widget.material.imageUrls.isNotEmpty)
              Image.network(
                '$baseUrl/materials/${widget.material.imageUrls[0]}/get_image',
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
            else
              _buildStyledPlaceholder(),

            // Overlay with gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
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

            // Category indicator
            Positioned(
              bottom: context.height * 0.015,
              left: context.width * 0.025,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.025,
                  vertical: context.height * 0.008,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
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
                    SizedBox(width: context.width * 0.01),
                    Text(
                      _getCategoryName(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Price indicator
            Positioned(
              top: context.height * 0.015,
              right: context.width * 0.025,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.02,
                  vertical: context.height * 0.006,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${widget.material.priceDzd.toInt()} DA',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
              padding: EdgeInsets.all(context.width * 0.04),
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
                size: context.width * 0.08,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: context.height * 0.01),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.03,
                vertical: context.height * 0.005,
              ),
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
    return Container(
      height: context.height * 0.08,
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Title with enhanced styling
          Flexible(
            child: Text(
              widget.material.title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTextColor,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Author or subject info
          if (widget.material.description.isNotEmpty == true) ...[
            SizedBox(height: context.height * 0.005),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.02,
                vertical: context.height * 0.004,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                widget.material.description,
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
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Container(
      height: context.height * 0.12,
      padding: EdgeInsets.all(context.width * 0.04),
      child: Column(
        children: [
          // Read More Button
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/book_details_screen',
                    arguments: widget.material,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: AppTheme.primaryColor.withOpacity(0.3),
                ),
                child: Row(
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
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: context.height * 0.008),

          // Order Button
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Handle order action
                  _showEnhancedOrderDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(
                    color: AppTheme.primaryColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: context.width * 0.02),
                    Text(
                      'Commander',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
  DeliveryType _selectedDeliveryType = DeliveryType.pickup;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // You can pre-fill with user's phone if available
  // _phoneController.text = "user_phone_number";

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
                              color: AppTheme.backgroundColor.withOpacity(0.3),
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
                                      padding: EdgeInsets.all(context.width * 0.02),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.material.title,
                                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryTextColor,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            _getCategoryName(),
                                            style: AppTheme.lightTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: AppTheme.secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: context.height * 0.015),
                                Divider(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                  thickness: 1,
                                ),
                                SizedBox(height: context.height * 0.015),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Prix total:',
                                      style: AppTheme.lightTheme.textTheme.bodyMedium
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
                                        color: AppTheme.successColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${widget.material.priceDzd.toStringAsFixed(0)} DA',
                                        style: AppTheme.lightTheme.textTheme.headlineSmall
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
                                  style: AppTheme.lightTheme.textTheme.titleMedium
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
                                      _selectedDeliveryType = DeliveryType.pickup;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(context.width * 0.03),
                                    decoration: BoxDecoration(
                                      color: _selectedDeliveryType == DeliveryType.pickup
                                          ? AppTheme.primaryColor.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: _selectedDeliveryType == DeliveryType.pickup
                                            ? AppTheme.primaryColor
                                            : Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Radio<DeliveryType>(
                                          value: DeliveryType.pickup,
                                          groupValue: _selectedDeliveryType,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedDeliveryType = value!;
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Retrait en magasin',
                                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.primaryTextColor,
                                                ),
                                              ),
                                              Text(
                                                'Gratuit - Retrait dans nos locaux',
                                                style: AppTheme.lightTheme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: AppTheme.secondaryTextColor,
                                                ),
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
                                      _selectedDeliveryType = DeliveryType.delivery;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(context.width * 0.03),
                                    decoration: BoxDecoration(
                                      color: _selectedDeliveryType == DeliveryType.delivery
                                          ? AppTheme.primaryColor.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: _selectedDeliveryType == DeliveryType.delivery
                                            ? AppTheme.primaryColor
                                            : Colors.grey.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Radio<DeliveryType>(
                                          value: DeliveryType.delivery,
                                          groupValue: _selectedDeliveryType,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedDeliveryType = value!;
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Livraison à domicile',
                                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.primaryTextColor,
                                                ),
                                              ),
                                              Text(
                                                'Livraison à votre adresse',
                                                style: AppTheme.lightTheme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: AppTheme.secondaryTextColor,
                                                ),
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
                          if (_selectedDeliveryType == DeliveryType.delivery) ...[
                            SizedBox(height: context.height * 0.02),
                            
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
                                    'Informations de livraison',
                                    style: AppTheme.lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryTextColor,
                                    ),
                                  ),
                                  SizedBox(height: context.height * 0.015),
                                  
                                  // Address Field
                                  TextField(
                                    controller: _addressController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      labelText: 'Adresse de livraison *',
                                      hintText: 'Entrez votre adresse complète',
                                      prefixIcon: Icon(
                                        Icons.location_on_rounded,
                                        color: AppTheme.primaryColor,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppTheme.primaryColor.withOpacity(0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppTheme.primaryColor.withOpacity(0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: context.width * 0.04,
                                        vertical: context.height * 0.015,
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: context.height * 0.015),
                                  
                                  // Phone Field
                                  TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: 'Numéro de téléphone *',
                                      hintText: 'Ex: 0555 123 456',
                                      prefixIcon: Icon(
                                        Icons.phone_rounded,
                                        color: AppTheme.primaryColor,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppTheme.primaryColor.withOpacity(0.3),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppTheme.primaryColor.withOpacity(0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: context.width * 0.04,
                                        vertical: context.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

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
                                        color: AppTheme.primaryColor.withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Annuler',
                                    style: AppTheme.lightTheme.textTheme.titleMedium
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
                                    if (_selectedDeliveryType == DeliveryType.delivery) {
                                      if (_addressController.text.trim().isEmpty ||
                                          _phoneController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Veuillez remplir tous les champs obligatoires',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            margin: EdgeInsets.all(context.width * 0.04),
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
                                            materialId: widget.material.id,
                                            quantity: 1,
                                            deliveryType: _selectedDeliveryType,
                                            deliveryAddress: _selectedDeliveryType == DeliveryType.delivery 
                                                ? _addressController.text.trim() 
                                                : null,
                                            deliveryPhone: _selectedDeliveryType == DeliveryType.delivery 
                                                ? _phoneController.text.trim() 
                                                : null,
                                          ),
                                        ],
                                        deliveryType: _selectedDeliveryType,
                                        deliveryAddress: _selectedDeliveryType == DeliveryType.delivery 
                                            ? _addressController.text.trim() 
                                            : null,
                                        deliveryPhone: _selectedDeliveryType == DeliveryType.delivery 
                                            ? _phoneController.text.trim() 
                                            : null,
                                      ),
                                    );
                                    
                                    FocusScope.of(context).unfocus();
                                    
                                    // Show success message
                                    String deliveryMessage = _selectedDeliveryType == DeliveryType.pickup 
                                        ? 'Commande confirmée pour retrait en magasin!'
                                        : 'Commande confirmée pour livraison!';

                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                        backgroundColor: AppTheme.successColor,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        margin: EdgeInsets.all(context.width * 0.04),
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
                                    shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: context.width * 0.05,
                                      ),
                                      SizedBox(width: context.width * 0.02),
                                      Text(
                                        'Confirmer',
                                        style: AppTheme.lightTheme.textTheme.titleMedium
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
    switch (widget.material.materialType.toLowerCase()) {
      case 'livre':
        return Icons.menu_book;
      case 'polycopie':
        return Icons.description;
      case 'cours':
        return Icons.school;
      default:
        return Icons.library_books;
    }
  }

  String _getCategoryName() {
    switch (widget.material.materialType.toLowerCase()) {
      case 'livre':
        return 'Livre';
      case 'polycopie':
        return 'Polycopié';
      case 'cours':
        return 'Cours';
      default:
        return 'Document';
    }
  }
}
