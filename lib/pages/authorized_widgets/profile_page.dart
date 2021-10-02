import 'package:elegionhack/app.dart';
import 'package:elegionhack/pages/authorized.dart';
import 'package:elegionhack/pages/authorized_widgets/edit_profile_page.dart';
import 'package:elegionhack/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePageElement extends StatelessWidget {
  const ProfilePageElement(
      {Key? key, required this.caption, required this.value})
      : super(key: key);

  final String caption;
  final String value;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return Row(
      children: [
        Expanded(child: Text(caption, style: style)),
        Expanded(
            child: Text(
          value,
          style: style,
        ))
      ],
    );
  }
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key, required this.idx}) : super(key: key);
  const ProfilePage.myProfile({Key? key})
      : idx = -1,
        super(key: key);

  final int idx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileProvider(idx));

    final content = userProfileState.map(
        data: (profile) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: const [
                    Image(
                        width: double.infinity,
                        image: AssetImage('images/pass_unvisiable.png')),
                    Positioned(
                        child: Text(
                          'Личный кабинет',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        bottom: 20,
                        left: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    ProfilePageElement(
                        caption: 'E-Mail', value: profile.value.email),
                    if (profile.value.phone != null)
                      ProfilePageElement(
                          caption: 'Телефон', value: profile.value.phone!),
                    if (profile.value.addPhone != null)
                      ProfilePageElement(
                          caption: 'Тел.д/экстр. связи',
                          value: profile.value.addPhone ?? ''),
                    ProfilePageElement(
                        caption: 'Роль',
                        value: profile.value.profileStatusToString),
                    if (profile.value.department != null)
                      ProfilePageElement(
                          caption: 'Подразделение',
                          value: profile.value.department!),
                    ProfilePageElement(
                        caption: 'Пол', value: profile.value.genderString)
                  ],
                ),
              ),
            ],
          );
        },
        loading: (_) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        error: (_) => const Text('error'));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(userProfileState.map(
              data: (profile) =>
                  '${profile.value.name} ${profile.value.patronymic} ${profile.value.surname}',
              loading: (_) => '',
              error: (_) => 'Error')),
          pinned: true,
          actions: [
            IconButton(
                onPressed: () {
                  ref.read(topNavigatorListener).currentState!.push(
                      AuthorizedPage.route(child: const EditProfilePage()));
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        SliverToBoxAdapter(
          child: content,
        )
      ],
    );
  }
}
