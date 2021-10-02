import 'package:elegionhack/colors.dart';
import 'package:elegionhack/pages/authorized_pages/widgets/button_with_arrow.dart';
import 'package:elegionhack/pages/authorized_pages/widgets/person_card.dart';
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: state.searchController,
            decoration: InputDecoration(
              filled: true,
              isCollapsed: true,
              hintText: 'Имя',
              suffixIcon: const Icon(Icons.search),
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        for (var user in state.profiles)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              ref.read(createTeamProvider).toggle(user.id);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: PersonCard(
                  profile: user, selected: state.selected.contains(user.id)),
            ),
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

    final _decoration = InputDecoration(
      filled: true,
      isCollapsed: true,
      hintText: 'Название',
      isDense: true,
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: TextField(
                      controller: controller, decoration: _decoration),
                ),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Text(
                        'Тимлидер',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                  child: state.map(
                      data: (data) => PersonCard(profile: data.value),
                      loading: (_) => const SizedBox.shrink(),
                      error: (_) => const SizedBox.shrink()),
                )
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: CreateTeamMembersList(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 150,
                  child: ButtonWithArrow(
                      callback: () {
                        ref.read(createTeamProvider).create();
                      },
                      caption: 'Сохранить'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
