import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities.dart';
import 'transfer_confirmation_screen.dart';

class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});
  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _mobile = TextEditingController(),
      _amount = TextEditingController(),
      _remarks = TextEditingController();
  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _amount.dispose();
    _remarks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Send money')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Beneficiary details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _name,
            validator: (value) => requiredValidator(value, 'Beneficiary name'),
            decoration: const InputDecoration(labelText: 'Beneficiary name'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _mobile,
            validator: mobileValidator,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: '10-digit mobile number',
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _amount,
            validator: amountValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Transfer amount (INR)',
              prefixText: '₹ ',
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _remarks,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Remarks (optional)'),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _reviewTransfer,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppColors.navy,
            ),
            child: const Text('Review transfer'),
          ),
        ],
      ),
    ),
  );
  void _reviewTransfer() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransferConfirmationScreen(
          request: TransferRequest(
            name: _name.text.trim(),
            mobile: _mobile.text,
            amount: double.parse(_amount.text),
            remarks: _remarks.text.trim().isEmpty ? null : _remarks.text.trim(),
          ),
        ),
      ),
    );
  }
}
