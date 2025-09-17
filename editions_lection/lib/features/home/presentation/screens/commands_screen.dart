import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/core/extensions/extensions.dart';
import 'package:editions_lection/features/home/presentation/blocs/commands_bloc/commands_bloc.dart';
import 'package:editions_lection/features/home/domain/entities/order.dart';

class CommandsScreen extends StatefulWidget {
  const CommandsScreen({super.key});

  @override
  State<CommandsScreen> createState() => _CommandsScreenState();
}

class _CommandsScreenState extends State<CommandsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  String _selectedFilter = 'all'; // all, pending, printing, ready, delivered

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

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
    await _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    if (_selectedFilter == 'all') return orders;
    return orders.where((order) => order.status == _selectedFilter).toList();
  }

  // Calculate total price for an order
  double _calculateOrderTotal(OrderEntity order) {
    return order.items.fold(0.0, (total, item) {
      return total + (item.material.priceDzd * item.quantity);
    });
  }

  // Calculate total price for all orders
  double _calculateAllOrdersTotal(List<OrderEntity> orders) {
    return orders.fold(0.0, (total, order) {
      return total + _calculateOrderTotal(order);
    });
  }

  // Format price in DZD
  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)} DA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<CommandsBloc>().add(FetchOrdersEvent());
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Animated Header
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: _buildHeader(),
                  ),
                ),
              ),

              // Total Price Section
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _contentSlideAnimation,
                  child: FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: _buildTotalPriceSection(),
                  ),
                ),
              ),

              // Filter Section
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _contentSlideAnimation,
                  child: FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: _buildFilterSection(),
                  ),
                ),
              ),

              // Orders List
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _contentSlideAnimation,
                  child: FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: _buildOrdersList(),
                  ),
                ),
              ),
            ],
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
                      Navigator.pop(context);
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
                  'Mes Commandes',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Suivez l\'état de vos commandes',
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

  Widget _buildTotalPriceSection() {
    return BlocBuilder<CommandsBloc, CommandsState>(
      builder: (context, state) {
        if (state is CommandsLoaded) {
          final filteredOrders = _filterOrders(state.orders);
          final totalPrice = _calculateAllOrdersTotal(filteredOrders);

          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: context.width * 0.05,
              vertical: context.height * 0.01,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: context.width * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total des commandes',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatPrice(totalPrice),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${filteredOrders.length} commande${filteredOrders.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      padding: const EdgeInsets.all(4),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('all', 'Tous', Icons.list_alt_rounded),
            _buildFilterChip('pending', 'En attente', Icons.access_time),
            _buildFilterChip('printing', 'Impression', Icons.print),
            _buildFilterChip('ready', 'Prêt', Icons.check_circle_outline),
            _buildFilterChip('delivered', 'Livré', Icons.local_shipping),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => setState(() => _selectedFilter = value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected
                      ? Colors.white
                      : AppTheme.primaryTextColor.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.primaryTextColor.withOpacity(0.7),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return Container(
      margin: EdgeInsets.only(top: context.height * 0.02),
      child: BlocBuilder<CommandsBloc, CommandsState>(
        builder: (context, state) {
          if (state is CommandsLoading) {
            return _buildLoadingState();
          } else if (state is CommandsLoaded) {
            final filteredOrders = _filterOrders(state.orders);

            if (filteredOrders.isEmpty) {
              return _buildEmptyState();
            }

            return _buildOrdersListView(filteredOrders);
          } else if (state is CommandsFailure) {
            return _buildErrorState(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
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
            'Chargement de vos commandes...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: context.height * 0.4,
      margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.bounceOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Icon(
                  _selectedFilter == 'all'
                      ? Icons.shopping_bag_outlined
                      : Icons.search_off_outlined,
                  size: 64,
                  color: AppTheme.primaryTextColor.withOpacity(0.5),
                ),
              );
            },
          ),
          SizedBox(height: context.height * 0.02),
          Text(
            _selectedFilter == 'all'
                ? 'Aucune commande trouvée'
                : 'Aucune commande ${_getFilterDisplayName(_selectedFilter)}',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.01),
          Text(
            _selectedFilter == 'all'
                ? 'Vous n\'avez pas encore passé de commandes'
                : 'Essayez de changer le filtre pour voir d\'autres commandes',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryTextColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (_selectedFilter != 'all') ...[
            SizedBox(height: context.height * 0.02),
            TextButton(
              onPressed: () => setState(() => _selectedFilter = 'all'),
              child: Text(
                'Voir toutes les commandes',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: context.height * 0.4,
      margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
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
                  color: AppTheme.errorColor.withOpacity(0.7),
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
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryTextColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.03),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<CommandsBloc>().add(FetchOrdersEvent()),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersListView(List<OrderEntity> orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: EnhancedCommandCard(
                  order: orders[index],
                  orderTotal: _calculateOrderTotal(orders[index]),
                  formatPrice: _formatPrice,
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'pending':
        return 'en attente';
      case 'printing':
        return 'en impression';
      case 'ready':
        return 'prêtes';
      case 'delivered':
        return 'livrées';
      default:
        return '';
    }
  }
}

class EnhancedCommandCard extends StatelessWidget {
  final OrderEntity order;
  final double orderTotal;
  final String Function(double) formatPrice;

  const EnhancedCommandCard({
    super.key,
    required this.order,
    required this.orderTotal,
    required this.formatPrice,
  });

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.access_time;
      case 'printing':
        return Icons.print;
      case 'ready':
        return Icons.check_circle_outline;
      case 'delivered':
        return Icons.local_shipping;
      default:
        return Icons.help_outline;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'printing':
        return const Color(0xFF2196F3); // Blue
      case 'ready':
        return AppTheme.successColor; // Green
      case 'delivered':
        return const Color(0xFF9E9E9E); // Grey
      default:
        return AppTheme.primaryTextColor;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'printing':
        return 'En cours d\'impression';
      case 'ready':
        return 'Prêt à être récupéré';
      case 'delivered':
        return 'Livré';
      default:
        return 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(4, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to order details
            // Navigator.pushNamed(context, '/order_details', arguments: order.id);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Commande #${order.id.substring(0, 8)}',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${order.appointmentDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Order Total Price
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              formatPrice(orderTotal),
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: getStatusColor(order.status).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getStatusIcon(order.status),
                            color: getStatusColor(order.status),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            getStatusText(order.status),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: getStatusColor(order.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Progress Indicator
                const SizedBox(height: 16),
                _buildProgressIndicator(order.status),

                const SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  color: AppTheme.borderColor,
                ),

                const SizedBox(height: 16),

                // Items Section
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Articles (${order.items.length})',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Items List
                ...order.items.take(3).map((item) {
                  final itemTotal = item.material.priceDzd * item.quantity;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item.material.materialType == 'book'
                                ? Icons.menu_book_rounded
                                : Icons.article_rounded,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.material.title,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Quantité: ${item.quantity}',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      formatPrice(itemTotal),
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Show more items indicator
                if (order.items.length > 3)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.more_horiz,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${order.items.length - 3} autres articles',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            order.deliveryType == DeliveryType.pickup
                                ? Icons.store_rounded
                                : Icons.local_shipping_rounded,
                            color: AppTheme.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.deliveryType == DeliveryType.pickup
                                ? 'Retrait en magasin'
                                : 'Livraison à domicile',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      if (order.deliveryType == DeliveryType.delivery) ...[
                        const SizedBox(height: 8),
                        if (order.deliveryAddress != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: AppTheme.secondaryTextColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  order.deliveryAddress!,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (order.deliveryPhone != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.phone_rounded,
                                color: AppTheme.secondaryTextColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                order.deliveryPhone!,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String status) {
    final steps = ['pending', 'printing', 'ready', 'delivered'];
    final currentStepIndex = steps.indexOf(status);

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = index <= currentStepIndex;
        final isActive = index == currentStepIndex;

        return Expanded(
          child: Row(
            children: [
              // Step Circle
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? getStatusColor(step)
                      : Colors.grey.withOpacity(0.3),
                  border: Border.all(
                    color: isActive
                        ? getStatusColor(step)
                        : Colors.grey.withOpacity(0.5),
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),

              // Progress Line
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: isCompleted
                        ? getStatusColor(step).withOpacity(0.5)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
