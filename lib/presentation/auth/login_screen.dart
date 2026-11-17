import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../wallet_provider.dart';
import '../widgets/app_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'demo@jstack.co');
  final _password = TextEditingController(text: 'Demo@123');
  bool _hide = true;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WalletProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 62,
                      color: AppColors.teal,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'jWallet Lite',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Simple, secure digital payments',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 42),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _email,
                      validator: emailValidator,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      validator: passwordValidator,
                      obscureText: _hide,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _hide = !_hide),
                          icon: Icon(
                            _hide
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: ErrorMessage(state.error!),
                      ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: state.loading ? null : _login,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: AppColors.navy,
                      ),
                      child: state.loading
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Log in'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Demo credentials are prefilled',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_form.currentState!.validate())
      await context.read<WalletProvider>().login(
        _email.text.trim(),
        _password.text,
      );
  }
}
