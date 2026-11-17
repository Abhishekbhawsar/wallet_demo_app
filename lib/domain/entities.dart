class User {
  const User({required this.id, required this.name, required this.email});
  final String id, name, email;
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
  );
}

class Wallet {
  const Wallet({
    required this.id,
    required this.currency,
    required this.balance,
    required this.maskedNumber,
  });
  final String id, currency, maskedNumber;
  final double balance;
  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json['walletId'] as String,
    currency: json['currency'] as String,
    balance: (json['availableBalance'] as num).toDouble(),
    maskedNumber: json['maskedAccountNumber'] as String,
  );
}

class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.person,
    required this.status,
    required this.createdAt,
    this.remarks,
  });
  final String id, type, currency, person, status;
  final double amount;
  final DateTime createdAt;
  final String? remarks;
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as String,
    type: json['type'] as String,
    amount: (json['amount'] as num).toDouble(),
    currency: json['currency'] as String,
    person:
        (json['beneficiaryName'] ?? json['senderName'] ?? 'Unknown') as String,
    status: json['status'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    remarks: json['remarks'] as String?,
  );
}

class TransferRequest {
  const TransferRequest({
    required this.name,
    required this.mobile,
    required this.amount,
    this.remarks,
  });
  final String name, mobile;
  final double amount;
  final String? remarks;
  Map<String, dynamic> toJson() => {
    'beneficiaryName': name,
    'mobileNumber': mobile,
    'amount': amount,
    'remarks': remarks,
  };
}

class TransferResult {
  const TransferResult({
    required this.id,
    required this.amount,
    required this.balance,
    required this.currency,
  });
  final String id, currency;
  final double amount, balance;
  factory TransferResult.fromJson(Map<String, dynamic> json) => TransferResult(
    id: json['transactionId'] as String,
    amount: (json['amount'] as num).toDouble(),
    balance: (json['availableBalance'] as num).toDouble(),
    currency: json['currency'] as String,
  );
}
