import 'package:elegionhack/edit_profile/edit_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePageContent extends ConsumerWidget {
  const EditProfilePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(editProfileProvider);
    return profileState.map(
        error: (_) => const Text('error'),
        loading: (_) => const Center(child: CircularProgressIndicator()),
        data: (state) {
          return Column(
            children: [
              Row(
                children: [
                  const Text('Телефон'),
                  Expanded(
                    child: TextField(
                      controller: state.value.phone,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text('Тел. д/экст. связи'),
                  Expanded(
                    child: TextField(
                      controller: state.value.addPhone,
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text('Изменение профиля'),
        ),
        SliverToBoxAdapter(
          child: EditProfilePageContent(),
        )
      ],
    );
  }

  static Route route() {
    return MaterialPageRoute(builder: (_) => const EditProfilePage());
  }
}
