import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/colors.dart';
import 'package:elegionhack/pages/authorized.dart';
import 'package:elegionhack/pages/authorized_pages/calendar_page.dart';
import 'package:elegionhack/pages/authorized_pages/notifications_page.dart';
import 'package:elegionhack/pages/authorized_pages/teams_page.dart';
import 'package:elegionhack/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerElement extends StatelessWidget {
  const DrawerElement(
      {Key? key, required this.callback, required this.caption, this.icon})
      : super(key: key);

  final String caption;
  final VoidCallback callback;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: InkWell(
        child: Row(
          children: [
            if (icon != null) icon!,
            Text(caption,
                style: icon != null
                    ? const TextStyle(
                        color: ELegionColors.eLegionLightBlue, fontSize: 18)
                    : null),
          ],
        ),
        onTap: callback,
      ),
    );
  }
}

class MainDrawer extends Drawer {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Consumer(
          builder: (context, ref, child) {
            final userProfile = ref.watch(userProfileProvider(-1));
            return userProfile.map(
                data: (value) => Flexible(
                      child: Column(
                        children: [
                          Expanded(
                            child: CircleAvatar(
                                maxRadius: 80,
                                backgroundImage: NetworkImage(
                                    'https://e-legion.newpage.xyz/files/avatar/${value.value.avatar}')),
                          ),
                          Text(
                            '${value.value.name} ${value.value.patronymic}',
                            style: const TextStyle(
                                color: ELegionColors.eLegionLightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(value.value.surname,
                              style: const TextStyle(
                                  color: ELegionColors.eLegionLightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                        ],
                      ),
                    ),
                loading: (_) => const Text(''),
                error: (_) => const Text(''));
          },
        ),
        DrawerElement(callback: () {}, caption: 'Личный профиль'),
        DrawerElement(
            callback: () {
              Navigator.of(context)
                  .push(AuthorizedPage.route(child: const TeamsPage()));
            },
            caption: 'Моя команда'),
        DrawerElement(callback: () {}, caption: 'Задачи'),
        DrawerElement(
            callback: () {
              Navigator.of(context)
                  .push(AuthorizedPage.route(child: const CalendarPage()));
            },
            caption: 'Календарь'),
        DrawerElement(
            callback: () {
              Navigator.of(context).push(
                  AuthorizedPage.route(child: const NotificationsScreen()));
            },
            caption: 'Рабочие чаты'),
        DrawerElement(callback: () {}, caption: 'Уведомления'),
        DrawerElement(callback: () {}, caption: 'Приветственная книга'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
              width: double.infinity),
        ),
        DrawerElement(callback: () {}, caption: 'О приложении'),
        Consumer(builder: (context, ref, child) {
          return DrawerElement(
              callback: () {
                ref.read(authStateNotifierProvider.notifier).logout();
              },
              caption: 'Выйти');
        }),
      ]),
    );
  }
}
