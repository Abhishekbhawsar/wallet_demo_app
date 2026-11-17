import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/wallet_repository.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/dashboard/dashboard_screen.dart';
import 'presentation/wallet_provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => WalletProvider(ApiWalletRepository())..restore(),
    child: const JWalletApp(),
  ),
);

class JWalletApp extends StatelessWidget {
  const JWalletApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'jWallet Lite',
    theme: appTheme(),
    home: const AppGate(),
  );
}

class AppGate extends StatelessWidget {
  const AppGate({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WalletProvider>();
    if (state.loading && !state.signedIn)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return state.signedIn ? const DashboardScreen() : const LoginScreen();
  }
}
