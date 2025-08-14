import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:editions_lection/core/theme/theme.dart';
import 'package:editions_lection/features/home/presentation/blocs/commands_bloc/commands_bloc.dart';
import 'package:editions_lection/features/home/domain/entities/order.dart';

class CommandsScreen extends StatelessWidget {
  const CommandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CommandsBloc, CommandsState>(
        builder: (context, state) {
          if (state is CommandsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CommandsLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Text(
                  'Aucune commande trouvée.',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return CommandCard(order: order);
              },
            );
          } else if (state is CommandsFailure) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CommandCard extends StatelessWidget {
  final OrderEntity order;

  const CommandCard({super.key, required this.order});

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
        return Colors.orange;
      case 'printing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.grey;
      default:
        return Colors.black;
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Commande #${order.id.substring(0, 8)}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      getStatusIcon(order.status),
                      color: getStatusColor(order.status),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      getStatusText(order.status),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Date de commande: ${order.appointmentDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            const Divider(height: 16, thickness: 1),
            Text(
              'Articles:',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    item.material.materialType == 'book' ? Icons.menu_book : Icons.article,
                    size: 18,
                    color: AppTheme.primaryTextColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${item.material.title} (x${item.quantity})',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}