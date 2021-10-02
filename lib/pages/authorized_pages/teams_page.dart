import 'package:elegionhack/colors.dart';
import 'package:elegionhack/pages/authorized.dart';
import 'package:elegionhack/pages/authorized_pages/create_team.dart';
import 'package:elegionhack/pages/authorized_pages/widgets/person_card.dart';
import 'package:elegionhack/profile/profile_model.dart';
import 'package:elegionhack/profile/profile_provider.dart';
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
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 18.0),
                            child: Text(
                              'Тимлидер',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      for (var member in teamInfo.value.members
                          .where((e) => e.role != ProfileStatus.legioner))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: PersonCard(
                            profile: member,
                            elevation: 0,
                            callback: () {
                              ref
                                  .read(teamsListProvider.notifier)
                                  .openFeedback(member.id);
                            },
                          ),
                        ),
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 18.0),
                            child: Text(
                              'Легионеры',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      for (var member in teamInfo.value.members
                          .where((e) => e.role == ProfileStatus.legioner))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: PersonCard(
                            profile: member,
                            elevation: 0,
                            callback: () {
                              ref
                                  .read(teamsListProvider.notifier)
                                  .openFeedback(member.id);
                            },
                          ),
                        )
                    ],
                  ),
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

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({Key? key}) : super(key: key);

  @override
  _TeamListScreenState createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    Tween<Offset> tween =
        Tween(begin: const Offset(0, -2), end: const Offset(0, 0.07));
    animation = tween.animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.listen<AsyncValue<TeamsList>>(teamsListProvider, (value) {
        value.whenData((value) {
          if (value.open) {
            controller.forward();
          } else {
            controller.reverse();
          }
        });
      });
      final state = ref.watch(teamsListProvider);
      return SlideTransition(
        position: animation,
        child: PhysicalModel(
            color: Colors.white,
            elevation: 16,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text('Перейти к команде'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: state.map(
                          data: (value) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 16),
                              child: ListView(
                                children: [
                                  for (var i = 0;
                                      i < value.value.teams.length;
                                      i++)
                                    MaterialButton(
                                      onPressed: () {
                                        ref.read(teamsListProvider.notifier)
                                          ..selectTeam(i)
                                          ..toggle();
                                      },
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                      child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Text(value.value.teams[i].team,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                            ],
                                          )),
                                    )
                                ],
                              ),
                            );
                          },
                          loading: (_) => const SizedBox.shrink(),
                          error: (_) => const SizedBox.shrink()),
                    ),
                    const Divider(color: Colors.grey),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(AuthorizedPage.route(
                            child: const CreateTeamScreen()));
                      },
                      child: Row(
                        children: const [
                          Text('Создать команду'),
                        ],
                      ),
                    )
                  ],
                ))),
      );
    });
  }
}

class FeedbackCreateScreen extends StatefulWidget {
  const FeedbackCreateScreen({Key? key}) : super(key: key);

  @override
  _FeedbackCreateScreenState createState() => _FeedbackCreateScreenState();
}

class _FeedbackCreateScreenState extends State<FeedbackCreateScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    Tween<Offset> tween =
        Tween(begin: const Offset(0, -2), end: const Offset(0, 0.07));
    animation = tween.animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String caption) => InputDecoration(
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
      );

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.listen<AsyncValue<TeamsList>>(teamsListProvider, (value) {
        value.whenData((value) {
          if (value.feedbackUserID != -1) {
            controller.forward();
          } else {
            controller.reverse();
          }
        });
      });
      final chatListState = ref.watch(teamsListProvider);

      return SlideTransition(
        position: animation,
        child: PhysicalModel(
            color: Colors.white,
            elevation: 16,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text(
                            'Добавить фидбек',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    chatListState.map(
                        data: (data) {
                          return Consumer(
                            builder: (context, bottomRef, child) {
                              final userInfo = bottomRef.watch(
                                  userProfileProvider(
                                      data.value.feedbackUserID));
                              return userInfo.map(
                                  data: (data) => PersonCard(
                                        profile: data.value,
                                        elevation: 0,
                                      ),
                                  loading: (_) => const SizedBox.shrink(),
                                  error: (_) => const SizedBox.shrink());
                            },
                          );
                        },
                        loading: (_) => const SizedBox.shrink(),
                        error: (_) => const SizedBox.shrink()),
                    const Divider(color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('Оценка результата'),
                          const SizedBox(
                            width: 10,
                          ),
                          for (var i = 0; i < 5; i++)
                            const Icon(
                              Icons.star,
                              size: 15,
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Column(
                        children: [
                          TextField(decoration: _decoration('Задача')),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(decoration: _decoration('Результат')),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                              maxLines: 3,
                              decoration: _decoration('Замечания и пожелания')),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        // Navigator.of(context).push(AuthorizedPage.route(
                        //     child: const CreateTeamScreen()));
                      },
                      child: Row(
                        children: const [
                          Text('Сохранить фидбек'),
                        ],
                      ),
                    )
                  ],
                ))),
      );
    });
  }
}

class TeamsPage extends ConsumerWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsList = ref.watch(teamsListProvider);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
        ref.read(teamsListProvider.notifier).openFeedback(-1);
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                foregroundColor: ELegionColors.eLegionLightBlue,
                title: Text(
                    teamsList.map(
                        data: (data) =>
                            data.value.teams[data.value.selectedTeam].team,
                        loading: (_) => '',
                        error: (_) => ''),
                    style: const TextStyle(color: Colors.black)),
                pinned: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        ref.read(teamsListProvider.notifier).toggle();
                      },
                      icon: const Icon(CupertinoIcons.add))
                ],
              ),
              SliverToBoxAdapter(
                  child: Container(
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.grey.shade300))),
                child: teamsList.map(
                    data: (data) {
                      if (data.value.teams.isEmpty) {
                        return const Center(child: Text('Команд нет'));
                      } else {
                        return const TeamContent();
                      }
                    },
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e) => Text(e.toString())),
              )),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                        onPressed: () {},
                        child: const Text('Перейти в рабочий чат')),
                    MaterialButton(
                      onPressed: () {},
                      child: const Text('Создать опрос'),
                    )
                  ],
                ),
              )
            ]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: teamsList.map(
                  data: (value) {
                    return const TeamListScreen();
                  },
                  loading: (_) => const SizedBox.shrink(),
                  error: (_) => const SizedBox.shrink()),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: teamsList.map(
                  data: (value) {
                    return const FeedbackCreateScreen();
                  },
                  loading: (_) => const SizedBox.shrink(),
                  error: (_) => const SizedBox.shrink()),
            ),
          ),
        ],
      ),
    );
  }
}
