import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../wallet_provider.dart';
import '../widgets/app_widgets.dart';
import 'transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _search = '', _filter = 'ALL';
  @override
  Widget build(BuildContext context) {
    final all = context.watch<WalletProvider>().transactions;
    final visible = all
        .where(
          (transaction) =>
              (_filter == 'ALL' || transaction.type == _filter) &&
              '${transaction.id} ${transaction.person}'.toLowerCase().contains(
                _search.toLowerCase(),
              ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction history')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _search = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search reference or name',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['ALL', 'CREDIT', 'DEBIT']
                  .map(
                    (filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          filter == 'ALL'
                              ? 'All'
                              : '${filter[0]}${filter.substring(1).toLowerCase()}',
                        ),
                        selected: _filter == filter,
                        onSelected: (_) => setState(() => _filter = filter),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: visible.isEmpty
                ? const EmptyState()
                : RefreshIndicator(
                    onRefresh: context.read<WalletProvider>().loadDashboard,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: visible.length,
                      itemBuilder: (_, index) =>
                          TransactionTile(transaction: visible[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
