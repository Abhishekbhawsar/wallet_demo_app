import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities.dart';
import 'transaction_details_screen.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.transaction, super.key});
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    final credit = transaction.type == 'CREDIT';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionDetailsScreen(transaction: transaction),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: credit
              ? const Color(0xFFD8F8E8)
              : const Color(0xFFFFE6E6),
          child: Icon(
            credit ? Icons.south_west : Icons.north_east,
            color: credit ? AppColors.success : AppColors.danger,
          ),
        ),
        title: Text(
          transaction.person,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${transaction.id} · ${appDate(transaction.createdAt)}\n${transaction.status}',
        ),
        isThreeLine: true,
        trailing: Text(
          '${credit ? '+' : '-'}${money(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: credit ? AppColors.success : AppColors.danger,
          ),
        ),
      ),
    );
  }
}
