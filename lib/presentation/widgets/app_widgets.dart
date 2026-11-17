import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE8E6),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(message, style: const TextStyle(color: AppColors.danger)),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text('No transactions found'),
        ],
      ),
    ),
  );
}

class DetailRow extends StatelessWidget {
  const DetailRow(this.label, this.value, {super.key});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black54)),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
