import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamsPage extends ConsumerWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomScrollView(slivers: [
      SliverAppBar(title: Text('Моя команда'), pinned: true),
      SliverToBoxAdapter(
        child: Center(
            child: Text('Здесь пока никого нет. Добавьте коллег в команду')),
      )
    ]);
  }
}
