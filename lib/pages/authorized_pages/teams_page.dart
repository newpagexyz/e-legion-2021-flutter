import 'package:elegionhack/colors.dart';
import 'package:elegionhack/pages/authorized.dart';
import 'package:elegionhack/pages/authorized_pages/create_team.dart';
import 'package:elegionhack/teams/teams_rep.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamContent extends ConsumerWidget {
  const TeamContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamsListProvider);
    return teams.map(
        data: (data) {
          final team = ref.watch(
              teamInfoProvider(data.value.teams[data.value.selectedTeam]));
          return team.map(
              data: (teamInfo) {
                if (teamInfo.value.members.isEmpty) {
                  return const Text(
                      'Здесь пока никого нет. Добавьте коллег в команду');
                }
                return Column(
                  children: [
                    for (var member in teamInfo.value.members) Text(member.name)
                  ],
                );
              },
              loading: (_) => const SizedBox.shrink(),
              error: (_) => const SizedBox.shrink());
        },
        loading: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (_) => const Text('Error'));
  }
}

class TeamsPage extends ConsumerWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsList = ref.watch(teamsListProvider);
    return CustomScrollView(slivers: [
      SliverAppBar(
        backgroundColor: Colors.white,
        foregroundColor: ELegionColors.eLegionLightBlue,
        title: Text(
            teamsList.map(
                data: (data) => data.value.teams[data.value.selectedTeam].team,
                loading: (_) => '',
                error: (_) => ''),
            style: const TextStyle(color: Colors.black)),
        pinned: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    AuthorizedPage.route(child: const CreateTeamScreen()));
              },
              icon: const Icon(CupertinoIcons.add))
        ],
      ),
      SliverToBoxAdapter(
          child: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300))),
        child: teamsList.map(
            data: (data) {
              if (data.value.teams.isEmpty) {
                return const Center(child: Text('Команд нет'));
              } else {
                return const TeamContent();
              }
            },
            loading: (_) => const Center(child: CircularProgressIndicator()),
            error: (e) => Text(e.toString())),
      ))
    ]);
  }
}
