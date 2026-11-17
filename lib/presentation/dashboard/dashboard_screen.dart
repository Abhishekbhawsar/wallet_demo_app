import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities.dart';
import '../transactions/history_screen.dart';
import '../transactions/transaction_tile.dart';
import '../transfer/transfer_form_screen.dart';
import '../wallet_provider.dart';
import '../widgets/app_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WalletProvider>();
    final wallet = state.wallet;
    if (wallet == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'jWallet Lite',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: state.logout,
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: state.loadDashboard,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
          children: [
            _Welcome(state.user!.name),
            const SizedBox(height: 22),
            _BalanceCard(wallet),
            const SizedBox(height: 24),
            const Text(
              'Quick actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Action(
                  Icons.send_rounded,
                  'Send money',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransferFormScreen(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _Action(
                  Icons.add_circle_outline,
                  'Add money',
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add money is a UI-only demo action.'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _Action(
                  Icons.receipt_long_outlined,
                  'History',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                  child: const Text('See all'),
                ),
              ],
            ),
            if (state.error != null)
              ErrorMessage(state.error!)
            else
              ...state.transactions
                  .take(5)
                  .map((t) => TransactionTile(transaction: t)),
            if (state.transactions.isEmpty && state.error == null)
              const EmptyState(),
          ],
        ),
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome(this.name);
  final String name;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        backgroundColor: AppColors.teal,
        child: Text(
          name.substring(0, 1),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome back,'),
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard(this.wallet);
  final Wallet wallet;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.navy,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available balance',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Text(
          money(wallet.balance),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              wallet.maskedNumber,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              wallet.currency,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.teal),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}
