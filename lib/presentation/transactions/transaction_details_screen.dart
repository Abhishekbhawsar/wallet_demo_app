import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities.dart';
import '../widgets/app_widgets.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({required this.transaction, super.key});
  final Transaction transaction;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Transaction details')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DetailRow('Transaction ID', transaction.id),
              DetailRow('Type', transaction.type),
              DetailRow('Amount', money(transaction.amount)),
              DetailRow('Beneficiary / sender', transaction.person),
              DetailRow('Status', transaction.status),
              DetailRow('Date & time', appDate(transaction.createdAt)),
              DetailRow('Remarks', transaction.remarks ?? '—'),
            ],
          ),
        ),
      ),
    ),
  );
}
