import 'dart:convert';
import 'package:elegionhack/api_constants.dart';
import 'package:elegionhack/auth/auth_model.dart';
import 'package:elegionhack/auth/auth_rep.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthStatus { initial, auth, unauth, loading }

class AuthState {
  final AuthStatus status;
  final Credentials? credentials;
  final String? error;

  AuthState({required this.status, this.credentials, this.error});

  AuthState.initial({this.error})
      : status = AuthStatus.initial,
        credentials = null;
  AuthState.auth({required this.credentials})
      : status = AuthStatus.auth,
        error = null;
  AuthState.unauth({this.error})
      : status = AuthStatus.unauth,
        credentials = null;
  AuthState.loading()
      : status = AuthStatus.loading,
        credentials = null,
        error = null;
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this.ref) : super(AuthState.initial()) {
    _init();
  }

  final ProviderRefBase ref;
  final _store = const FlutterSecureStorage();

  void _init() async {
    final _id = await _store.read(key: 'id');
    final _token = await _store.read(key: 'token');

    if (_id != null && _token != null) {
      state = AuthState.auth(credentials: Credentials(id: _id, token: _token));
    } else {
      state = AuthState.unauth();
    }
  }

  void logout() async {
    await Future.wait(
        [_store.delete(key: 'session'), _store.delete(key: 'token')]);
    state = AuthState.unauth();
  }

  void login({required LoginPassword creds}) async {
    state = AuthState.loading();

    final client = ref.read(httpClientRepository);

    try {
      final response = await client.post(Uri.parse(LoginApi.login),
          body: {'email': creds.email, 'password': creds.password});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body.toString());
        if (json['body'] != false) {
          final credentials = Credentials.fromJson(json['body']);
          state = AuthState.auth(credentials: credentials);

          await _store.write(key: 'id', value: credentials.id);
          await _store.write(key: 'token', value: credentials.token);
        } else {
          state = AuthState.initial(error: 'Could not authorized');
        }
      } else {
        state = AuthState.initial(error: 'Could not authorized');
      }
    } catch (e) {
      state = AuthState.unauth(error: e.toString());
    }
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>(
        (ref) => AuthStateNotifier(ref));
