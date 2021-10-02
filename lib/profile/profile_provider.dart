import 'dart:convert';

import 'package:elegionhack/api_constants.dart';
import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/auth/auth_rep.dart';
import 'package:elegionhack/profile/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<Profile>> {
  ProfileNotifier(this.idx, {required this.ref})
      : super(const AsyncValue.loading()) {
    _init(idx);
  }

  int idx;

  void reload() async {
    await _init(idx);
  }

  Future<void> _init(int idx) async {
    final client = ref.read(httpClientRepository);
    final credentials = ref.watch(authStateNotifierProvider);
    if (credentials.credentials != null) {
      final data = idx == -1
          ? {'token': credentials.credentials!.token}
          : {'uid': idx.toString()};

      final response =
          await client.post(Uri.parse(UserApi.fetchUser), body: data);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body.toString());
        if (json['body'] != false) {
          final body = json['body'];
          state = AsyncValue.data(Profile.fromJson(body));
        } else {
          state = AsyncValue.error('error');
        }
      } else {
        state = AsyncValue.error('error');
      }
    }
  }

  final ProviderRefBase ref;
}

final userProfileProvider = StateNotifierProvider.autoDispose
    .family<ProfileNotifier, AsyncValue<Profile>, int>(
        (ref, idx) => ProfileNotifier(idx, ref: ref));
