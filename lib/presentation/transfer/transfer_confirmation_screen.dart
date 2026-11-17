import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities.dart';
import '../wallet_provider.dart';
import '../widgets/app_widgets.dart';
import 'transfer_success_screen.dart';

class TransferConfirmationScreen extends StatelessWidget {
  const TransferConfirmationScreen({required this.request, super.key});
  final TransferRequest request;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WalletProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm transfer')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Review before sending',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    DetailRow('To', request.name),
                    DetailRow('Mobile', request.mobile),
                    DetailRow('Amount', money(request.amount)),
                    DetailRow('Remarks', request.remarks ?? '—'),
                  ],
                ),
              ),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: ErrorMessage(state.error!),
              ),
            const Spacer(),
            FilledButton(
              onPressed: state.loading ? null : () => _submit(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.navy,
              ),
              child: state.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm & send'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final result = await context.read<WalletProvider>().transfer(request);
    if (context.mounted && result != null)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => TransferSuccessScreen(
            result: result,
            beneficiaryName: request.name,
          ),
        ),
        (route) => route.isFirst,
      );
  }
}
