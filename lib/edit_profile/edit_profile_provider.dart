import 'package:elegionhack/profile/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileState {
  final phone = TextEditingController();
  final addPhone = TextEditingController();
}

class EditProfileStateNotifier
    extends StateNotifier<AsyncValue<EditProfileState>> {
  EditProfileStateNotifier(this.ref) : super(const AsyncLoading()) {
    _init();
  }

  final ProviderRefBase ref;

  void _init() async {
    final profile = ref.read(userProfileProvider(-1));

    profile.whenData((value) {
      state = AsyncData(EditProfileState()
        ..addPhone.text = value.addPhone ?? ''
        ..phone.text = value.phone ?? '');
    });
  }

  void save() async {
    state.whenData((value) {
      state = const AsyncLoading();
      // TODO Save Profile
      _init();
    });
  }
}

final editProfileProvider =
    StateNotifierProvider<EditProfileStateNotifier, AsyncValue<EditProfileState>>((ref) => EditProfileStateNotifier(ref));
