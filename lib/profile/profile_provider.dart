import 'package:elegionhack/api_constants.dart';
import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/auth/auth_rep.dart';
import 'package:elegionhack/profile/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<Profile>> {
  ProfileNotifier(idx, {required this.ref})
      : super(const AsyncValue.loading()) {
    _init(idx);
  }

  void _init(int idx) async {
    final client = ref.read(httpClientRepository);
    final credentials = ref.watch(authStateNotifierProvider);
    if (credentials.credentials != null) {
      //TODO Real API
      final data = {
        'session': credentials.credentials!.session,
        'token': credentials.credentials!.token
      };
      if (idx != -1) data['uid'] = idx.toString();

      await client.post(Uri.parse(UserApi.fetchUser), body: data);
      await Future.delayed(const Duration(seconds: 1));
      state =
          AsyncValue.data(Profile.empty(idx).copyWith(phone: '+88005553535'));
    }
  }

  final ProviderRefBase ref;
}

final userProfileProvider = StateNotifierProvider.autoDispose
    .family<ProfileNotifier, AsyncValue<Profile>, int>(
        (ref, idx) => ProfileNotifier(idx, ref: ref));
