import 'package:editions_lection/core/constants/end_points.dart';
import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/domain/entities/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order.dart';
import '../blocs/commands_bloc/commands_bloc.dart';

class MaterialGridItem extends StatefulWidget {
  final MaterialEntity material;
  final VoidCallback onTap;

  const MaterialGridItem({
    super.key,
    required this.material,
    required this.onTap,
  });

  @override
  State<MaterialGridItem> createState() => _MaterialGridItemState();
}

class _MaterialGridItemState extends State<MaterialGridItem>
    with TickerProviderStateMixin {
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
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          double pressScale = 1.0 - (_pressController.value * 0.02);

          return Transform.scale(
            scale: pressScale,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
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
    );
  }

  Widget _buildImageSection(BuildContext context) {
    String baseUrl = EndPoints.baseUrl;
    return Container(
      height: context.height * 0.18,
      width: double.infinity,
      margin: EdgeInsets.all(context.width * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
                      Colors.black.withOpacity(0.03),
                    ],
                  ),
                ),
              ),
            ),

            // Category indicator
            Positioned(
              bottom: context.height * 0.01,
              left: context.width * 0.02,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.02,
                  vertical: context.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
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
                      size: 12,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: context.width * 0.008),
                    Text(
                      _getCategoryName(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Price indicator
            Positioned(
              top: context.height * 0.01,
              right: context.width * 0.02,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.015,
                  vertical: context.height * 0.004,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
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
                    fontSize: 10,
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
              size: 32,
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
              padding: EdgeInsets.all(context.width * 0.025),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getCategoryIcon(),
                size: context.width * 0.05,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: context.height * 0.008),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.02,
                vertical: context.height * 0.003,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Aperçu',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
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
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.03,
        vertical: context.height * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.material.title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: context.height * 0.005),

          // Module info
          if (widget.material.module.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.02,
                vertical: context.height * 0.003,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                widget.material.module,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          SizedBox(height: context.height * 0.005),

          // Description
          if (widget.material.description.isNotEmpty)
            Text(
              widget.material.description,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryTextColor.withOpacity(0.7),
                height: 1.2,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.03),
      child: Column(
        children: [
          // Read More Button
          SizedBox(
            width: double.infinity,
            height: context.height * 0.04,
            child: ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                shadowColor: AppTheme.primaryColor.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  SizedBox(width: context.width * 0.015),
                  Text(
                    'Lire plus',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: context.height * 0.006),

          // Order Button
          SizedBox(
            width: double.infinity,
            height: context.height * 0.04,
            child: OutlinedButton(
              onPressed: () {
                _showEnhancedOrderDialog(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 14,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: context.width * 0.015),
                  Text(
                    'Commander',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
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
    int currentStep = 1; // Track current step (1, 2, or 3)

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
                  maxHeight: context.height * 0.85,
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
                            // Step Indicator
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: context.height * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStepIndicator(1, currentStep, context),
                                  _buildStepLine(context),
                                  _buildStepIndicator(2, currentStep, context),
                                  _buildStepLine(context),
                                  _buildStepIndicator(3, currentStep, context),
                                ],
                              ),
                            ),

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
                                currentStep == 1
                                    ? Icons.shopping_cart_rounded
                                    : currentStep == 2
                                        ? Icons.local_shipping_rounded
                                        : Icons.location_on_rounded,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ),

                            SizedBox(height: context.height * 0.02),

                            // Title based on step
                            Text(
                              currentStep == 1
                                  ? 'Confirmer la commande'
                                  : currentStep == 2
                                      ? 'Type de livraison'
                                      : 'Informations de livraison',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: context.height * 0.02),

                            // Step 1: Product Information
                            if (currentStep == 1) ...[
                              Container(
                                padding: EdgeInsets.all(context.width * 0.04),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.backgroundColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.2),
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
                                                widget.material.title,
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
                                                _getCategoryName(),
                                                style: AppTheme.lightTheme
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: AppTheme
                                                      .secondaryTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: context.height * 0.015),
                                    Divider(
                                      color: AppTheme.primaryColor
                                          .withOpacity(0.2),
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
                                            '${widget.material.priceDzd.toStringAsFixed(0)} DA',
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
                            ],

                            // Step 2: Delivery Type Selection
                            if (currentStep == 2) ...[
                              Container(
                                padding: EdgeInsets.all(context.width * 0.0001),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Pickup Option
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDeliveryType =
                                              DeliveryType.pickup;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            context.width * 0.004),
                                        decoration: BoxDecoration(
                                          color: selectedDeliveryType ==
                                                  DeliveryType.pickup
                                              ? AppTheme.primaryColor
                                                  .withOpacity(0.1)
                                              : Colors.grey.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: selectedDeliveryType ==
                                                    DeliveryType.pickup
                                                ? AppTheme.primaryColor
                                                : Colors.grey.withOpacity(0.3),
                                            width: 2,
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
                                              activeColor:
                                                  AppTheme.primaryColor,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(
                                                  context.width * 0.025),
                                              decoration: BoxDecoration(
                                                color: AppTheme.primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.store_rounded,
                                                color: AppTheme.primaryColor,
                                                size: 24,
                                              ),
                                            ),
                                            SizedBox(
                                                width: context.width * 0.04),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Retrait en magasin',
                                                    style: AppTheme.lightTheme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppTheme
                                                          .primaryTextColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: context.height *
                                                          0.005),
                                                  Text(
                                                    'Gratuit - Retrait dans nos locaux',
                                                    style: AppTheme.lightTheme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                      color: AppTheme
                                                          .secondaryTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: context.height * 0.02),

                                    // Delivery Option
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDeliveryType =
                                              DeliveryType.delivery;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            context.width * 0.004),
                                        decoration: BoxDecoration(
                                          color: selectedDeliveryType ==
                                                  DeliveryType.delivery
                                              ? AppTheme.primaryColor
                                                  .withOpacity(0.1)
                                              : Colors.grey.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: selectedDeliveryType ==
                                                    DeliveryType.delivery
                                                ? AppTheme.primaryColor
                                                : Colors.grey.withOpacity(0.3),
                                            width: 2,
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
                                              activeColor:
                                                  AppTheme.primaryColor,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(
                                                  context.width * 0.025),
                                              decoration: BoxDecoration(
                                                color: AppTheme.primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                Icons.local_shipping_rounded,
                                                color: AppTheme.primaryColor,
                                                size: 24,
                                              ),
                                            ),
                                            SizedBox(
                                                width: context.width * 0.04),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Livraison à domicile',
                                                    style: AppTheme.lightTheme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppTheme
                                                          .primaryTextColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: context.height *
                                                          0.005),
                                                  Text(
                                                    'Livraison à votre adresse',
                                                    style: AppTheme.lightTheme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                      color: AppTheme
                                                          .secondaryTextColor,
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
                            ],

                            // Step 3: Delivery Details
                            if (currentStep == 3) ...[
                              Container(
                                padding: EdgeInsets.all(context.width * 0.04),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Address Field
                                    Container(
                                      height: context.height * 0.07,
                                      child: TextField(
                                        controller: addressController,
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Adresse',
                                          labelStyle: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          prefixIcon: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(
                                              Icons.location_on_rounded,
                                              color: AppTheme.primaryColor,
                                              size: 24,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: AppTheme.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: context.width * 0.04,
                                            vertical: context.height * 0.02,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: context.height * 0.02),

                                    // Phone Field
                                    SizedBox(
                                      height: context.height * 0.07,
                                      child: TextField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Numéro de téléphone *',
                                          labelStyle: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          hintText: 'Ex: 0555 123 456',
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                          ),
                                          prefixIcon: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(
                                              Icons.phone_rounded,
                                              color: AppTheme.primaryColor,
                                              size: 24,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: AppTheme.primaryColor,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: context.width * 0.04,
                                            vertical: context.height * 0.02,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
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
                                // Back/Cancel Button
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      if (currentStep > 1) {
                                        setState(() {
                                          currentStep--;
                                        });
                                      } else {
                                        Navigator.of(context).pop();
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: context.height * 0.018,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      currentStep > 1 ? 'Retour' : 'Annuler',
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
                                // Next/Confirm Button
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (currentStep == 1) {
                                        // Go to step 2
                                        setState(() {
                                          currentStep = 2;
                                        });
                                      } else if (currentStep == 2) {
                                        if (selectedDeliveryType ==
                                            DeliveryType.pickup) {
                                          // Confirm pickup order
                                          Navigator.of(context).pop();
                                          _confirmOrder(context,
                                              selectedDeliveryType, null, null);
                                        } else {
                                          // Go to step 3 for delivery details
                                          setState(() {
                                            currentStep = 3;
                                          });
                                        }
                                      } else if (currentStep == 3) {
                                        // Validate and confirm delivery order
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
                                        Navigator.of(context).pop();
                                        _confirmOrder(
                                          context,
                                          selectedDeliveryType,
                                          addressController.text.trim(),
                                          phoneController.text.trim(),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: context.height * 0.018,
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
                                          currentStep == 3 ||
                                                  (currentStep == 2 &&
                                                      selectedDeliveryType ==
                                                          DeliveryType.pickup)
                                              ? Icons.check_circle_rounded
                                              : Icons.arrow_forward_rounded,
                                          size: context.width * 0.05,
                                        ),
                                        SizedBox(width: context.width * 0.02),
                                        Text(
                                          currentStep == 1
                                              ? 'Suivant'
                                              : currentStep == 2
                                                  ? (selectedDeliveryType ==
                                                          DeliveryType.pickup
                                                      ? 'Confirmer'
                                                      : 'Suivant')
                                                  : 'Confirmer',
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

// Helper method to build step indicators
  Widget _buildStepIndicator(int step, int currentStep, BuildContext context) {
    bool isActive = step <= currentStep;
    bool isCurrent = step == currentStep;

    return Container(
      width: context.width * 0.1,
      height: context.width * 0.1,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isActive && step < currentStep
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: context.width * 0.05,
              )
            : Text(
                step.toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: context.width * 0.035,
                ),
              ),
      ),
    );
  }

// Helper method to build step connecting lines
  Widget _buildStepLine(BuildContext context) {
    return Container(
      width: context.width * 0.08,
      height: 2,
      color: Colors.grey.shade300,
      margin: EdgeInsets.symmetric(horizontal: context.width * 0.01),
    );
  }

// Helper method to confirm order
  void _confirmOrder(BuildContext context, DeliveryType deliveryType,
      String? address, String? phone) {
    // Create order with delivery details
    context.read<CommandsBloc>().add(
          CreateOrderEvent(
            orders: [
              OrderCreateEntity(
                materialId: widget.material.id,
                quantity: 1,
                deliveryType: deliveryType,
                deliveryAddress: address,
                deliveryPhone: phone,
              ),
            ],
            deliveryType: deliveryType,
            deliveryAddress: address,
            deliveryPhone: phone,
          ),
        );

    FocusScope.of(context).unfocus();

    // Show success message
    String deliveryMessage = deliveryType == DeliveryType.pickup
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
