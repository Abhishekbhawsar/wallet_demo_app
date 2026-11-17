import 'package:flutter/foundation.dart';

import '../data/wallet_repository.dart';
import '../domain/entities.dart';

class WalletProvider extends ChangeNotifier {
  WalletProvider(this._repo);
  final WalletRepository _repo;
  User? user;
  Wallet? wallet;
  List<Transaction> transactions = [];
  bool loading = false;
  String? error;
  bool get signedIn => user != null;
  Future<void> restore() async {
    if (await _repo.hasSession()) {
      await loadDashboard();
    }
  }

  Future<bool> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      user = await _repo.login(email, password);
      await loadDashboard(silent: true);
      return true;
    } on AppException catch (e) {
      error = e.message;
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadDashboard({bool silent = false}) async {
    if (!silent) {
      loading = true;
      error = null;
      notifyListeners();
    }
    try {
      final values = await Future.wait([
        _repo.profile(),
        _repo.wallet(),
        _repo.transactions(),
      ]);
      user = values[0] as User;
      wallet = values[1] as Wallet;
      transactions = values[2] as List<Transaction>;
    } on AppException catch (e) {
      error = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<TransferResult?> transfer(TransferRequest request) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await _repo.transfer(request);
      await loadDashboard(silent: true);
      return result;
    } on AppException catch (e) {
      error = e.message;
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    user = null;
    wallet = null;
    transactions = [];
    error = null;
    notifyListeners();
  }
}
