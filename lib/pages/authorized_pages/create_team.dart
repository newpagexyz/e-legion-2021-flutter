import 'package:elegionhack/colors.dart';
import 'package:elegionhack/pages/authorized_pages/widgets/button_with_arrow.dart';
import 'package:elegionhack/profile/profile_provider.dart';
import 'package:elegionhack/teams/teams_rep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTeamMembersList extends ConsumerWidget {
  const CreateTeamMembersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createTeamProvider).value;

    return Column(
      children: [
        TextField(controller: state.searchController),
        for (var user in state.profiles)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              ref.read(createTeamProvider).toggle(user.id);
            },
            child: Container(
                color: !state.selected.contains(user.id)
                    ? Colors.white
                    : Colors.amber,
                child: Column(
                  children: [
                    Text('${user.name} ${user.patronymic} ${user.surname}'),
                    Text('${user.post}')
                  ],
                )),
          )
      ],
    );
  }
}

class CreateTeamScreen extends ConsumerWidget {
  const CreateTeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProfileProvider(-1));
    final controller = ref.watch(
        createTeamProvider.select((value) => value.value.nameController));
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Colors.white,
          foregroundColor: ELegionColors.eLegionLightBlue,
          title: Text(
            'Создание команды',
            style: TextStyle(color: Colors.black),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300))),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                ),
                const Text('Тимлидер'),
                state.map(
                    data: (data) => Text(data.value.name),
                    loading: (_) => const SizedBox.shrink(),
                    error: (_) => const SizedBox.shrink())
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: CreateTeamMembersList(),
        ),
        SliverToBoxAdapter(
          child: ButtonWithArrow(
              callback: () {
                ref.read(createTeamProvider).create();
              },
              caption: 'Сохранить'),
        )
      ],
    );
  }
}
