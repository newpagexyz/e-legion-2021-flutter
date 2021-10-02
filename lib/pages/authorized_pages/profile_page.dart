import 'package:elegionhack/app.dart';
import 'package:elegionhack/pages/authorized.dart';
import 'package:elegionhack/pages/authorized_pages/edit_profile_page.dart';
import 'package:elegionhack/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePageElement extends StatelessWidget {
  const ProfilePageElement(
      {Key? key, required this.caption, required this.value})
      : super(key: key);

  final String caption;
  final String value;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(caption, style: style)),
          Expanded(
              child: Text(
            value,
            style: style,
          ))
        ],
      ),
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
                  children: [
                    (profile.value.avatar == null)
                        ? const Image(
                            width: double.infinity,
                            image: AssetImage('images/pass_unvisiable.png'))
                        : Image(
                            width: double.infinity,
                            image: NetworkImage(
                                'https://e-legion.newpage.xyz/files/avatar/${profile.value.avatar}')),
                    const Positioned(
                        child: Text(
                          ' Личный\nкабинет',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
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
                    if (profile.value.department?.isNotEmpty ?? false)
                      ProfilePageElement(
                          caption: 'Подразделение',
                          value: profile.value.department!),
                    ProfilePageElement(
                        caption: 'Пол', value: profile.value.genderString),
                    if (profile.value.dateOfEmployement?.isNotEmpty ?? false)
                      ProfilePageElement(
                          caption: 'Трудоустроен',
                          value: profile.value.dateOfEmployement!),
                    if (profile.value.firstDayOnWork?.isNotEmpty ?? false)
                      ProfilePageElement(
                          caption: 'Начало работы',
                          value: profile.value.firstDayOnWork!),
                    if (profile.value.post?.isNotEmpty ?? false)
                      ProfilePageElement(
                          caption: 'Должность', value: profile.value.post!),
                    if (profile.value.telegram?.isNotEmpty ?? false)
                      Row(
                        children: [
                          MaterialButton(
                              onPressed: () {
                                launch(
                                    'https://t.me/${profile.value.telegram!}');
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.message),
                                  Text('Telegram'),
                                ],
                              )),
                        ],
                      )
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

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(userProfileProvider(idx).notifier).reload();
      },
      child: CustomScrollView(
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
      ),
    );
  }
}
