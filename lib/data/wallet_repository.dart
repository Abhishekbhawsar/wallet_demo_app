import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities.dart';

class AppException implements Exception {
  AppException(this.message);
  final String message;
  @override
  String toString() => message;
}

abstract class WalletRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<bool> hasSession();
  Future<User> profile();
  Future<Wallet> wallet();
  Future<List<Transaction>> transactions();
  Future<Transaction> transaction(String id);
  Future<TransferResult> transfer(TransferRequest request);
}

class ApiWalletRepository implements WalletRepository {
  ApiWalletRepository({
    String baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:3000/api/v1',
    ),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),
         ),
       );
  final Dio _dio;
  static const _tokenKey = 'access_token';
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();
  Future<Options> get _auth async {
    final token = (await _prefs).getString(_tokenKey);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Never _throw(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      throw AppException(
        data is Map && data['message'] != null
            ? data['message'].toString()
            : 'Unable to reach the server. Check that the API is running.',
      );
    }
    throw AppException(error.toString());
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final r = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      await (await _prefs).setString(_tokenKey, r.data['data']['accessToken']);
      return User.fromJson(Map<String, dynamic>.from(r.data['data']['user']));
    } catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> logout() async => (await _prefs).remove(_tokenKey);
  @override
  Future<bool> hasSession() async => (await _prefs).containsKey(_tokenKey);
  @override
  Future<User> profile() async {
    try {
      final r = await _dio.get('/users/profile', options: await _auth);
      return User.fromJson(Map<String, dynamic>.from(r.data['data']));
    } catch (e) {
      _throw(e);
    }
  }

  @override
  Future<Wallet> wallet() async {
    try {
      final r = await _dio.get('/wallet/balance', options: await _auth);
      return Wallet.fromJson(Map<String, dynamic>.from(r.data['data']));
    } catch (e) {
      _throw(e);
    }
  }

  @override
  Future<List<Transaction>> transactions() async {
    try {
      final r = await _dio.get('/transactions', options: await _auth);
      return (r.data['data'] as List)
          .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      _throw(e);
    }
  }

  @override
  Future<Transaction> transaction(String id) async {
    try {
      final r = await _dio.get('/transactions/$id', options: await _auth);
      return Transaction.fromJson(Map<String, dynamic>.from(r.data['data']));
    } catch (e) {
      _throw(e);
    }
  }

  @override
  Future<TransferResult> transfer(TransferRequest request) async {
    try {
      final r = await _dio.post(
        '/transactions/transfer',
        data: request.toJson(),
        options: (await _auth).copyWith(
          headers: {
            ...(await _auth).headers ?? {},
            'Idempotency-Key': const Uuid().v4(),
          },
        ),
      );
      return TransferResult.fromJson(Map<String, dynamic>.from(r.data['data']));
    } catch (e) {
      _throw(e);
    }
  }
}
