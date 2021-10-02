import 'package:elegionhack/edit_profile/edit_profile_provider.dart';
import 'package:elegionhack/pages/authorized_widgets/button_with_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileRow extends StatelessWidget {
  const EditProfileRow(
      {Key? key, required this.caption, required this.controller})
      : super(key: key);
  final String caption;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(caption)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  isCollapsed: true,
                  hintText: caption,
                  isDense: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                )),
          ),
        )
      ],
    );
  }
}

class EditProfileAvatarHeader extends ConsumerWidget {
  const EditProfileAvatarHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAvatar = ref.watch(editProfileProvider).value;

    return profileAvatar.map(
        data: (data) {
          return Row(
            children: [
              SizedBox.square(
                  dimension: 100,
                  child: (data.value.selectedAvatar != null)
                      ? CircleAvatar(
                          minRadius: 20,
                          backgroundImage:
                              FileImage(data.value.selectedAvatar!),
                        )
                      : (data.value.fetchedAvatar != null)
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data.value.fetchedAvatar!))
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/logo60.png'))),
              Column(
                children: [
                  MaterialButton(
                      onPressed: () {}, child: const Text('Посмотреть фото')),
                  MaterialButton(
                      onPressed: () {
                        ref.read(editProfileProvider).changeAvatar();
                      },
                      child: const Text('Изменить фото'))
                ],
              )
            ],
          );
        },
        loading: (_) => const Flexible(
              flex: 2,
              child: Center(child: CircularProgressIndicator()),
            ),
        error: (_) => const Text('Error'));
  }
}

class EditProfilePageContent extends ConsumerWidget {
  const EditProfilePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(editProfileProvider).value;
    return profileState.map(
        error: (_) => const Text('error'),
        loading: (_) => const Center(child: CircularProgressIndicator()),
        data: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EditProfileAvatarHeader(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Личная информация'),
                ),
                EditProfileRow(
                    caption: 'Телефон', controller: state.value.phone),
                EditProfileRow(
                    caption: 'Тел.д/экстр. связи',
                    controller: state.value.addPhone),
                EditProfileRow(
                    caption: 'Дата рождения',
                    controller: state.value.birthdateController),
                EditProfileRow(
                    caption: 'Skype', controller: state.value.skypeController),
                EditProfileRow(
                    caption: 'Telegram',
                    controller: state.value.telegramController),
                ButtonWithArrow(
                  callback: () {},
                  caption: 'Сохранить',
                  horizontal: true,
                )
              ],
            ),
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
