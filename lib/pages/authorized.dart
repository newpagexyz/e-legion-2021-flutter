import 'package:elegionhack/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthorizedPage extends StatelessWidget {
  const AuthorizedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return MaterialButton(
          onPressed: () =>
              ref.read(authStateNotifierProvider.notifier).logout(),
          child: const Text('logout'),
        );
      }),
    ));
  }

  static Route route() {
    return MaterialPageRoute(builder: (context) => const AuthorizedPage());
  }
}
