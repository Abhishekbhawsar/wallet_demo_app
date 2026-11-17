import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities.dart';
import '../widgets/app_widgets.dart';

class TransferSuccessScreen extends StatelessWidget {
  const TransferSuccessScreen({
    required this.result,
    required this.beneficiaryName,
    super.key,
  });
  final TransferResult result;
  final String beneficiaryName;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, size: 90, color: AppColors.teal),
            const SizedBox(height: 20),
            const Text(
              'Transfer successful',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${money(result.amount)} sent to $beneficiaryName',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    DetailRow('Reference', result.id),
                    DetailRow('New balance', money(result.balance)),
                    DetailRow('Date & time', appDate(DateTime.now())),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.navy,
              ),
              child: const Text('Back to dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}
