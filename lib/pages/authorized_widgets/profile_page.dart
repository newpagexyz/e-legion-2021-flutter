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
    return Row(
      children: [Text(caption), Text(value)],
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
              ProfilePageElement(caption: 'Имя', value: profile.value.name)
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
              data: (profile) => profile.value.name,
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
