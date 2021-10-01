import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/pages/authorized_widgets/profile_page.dart';
import 'package:elegionhack/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elegionhack/pages/pages.dart';

final topNavigatorProvider = Provider((_) => GlobalKey<NavigatorState>());
final topNavigatorListener = Provider((ref) {
  final _navigator = ref.watch(topNavigatorProvider);
  ref.listen<AuthState>(authStateNotifierProvider, (value) {
    switch (value.status) {
      case AuthStatus.auth:
        _navigator.currentState!.pushAndRemoveUntil(
            AuthorizedPage.route(child: const ProfilePage.myProfile()),
            (route) => false);
        break;
      case AuthStatus.unauth:
        _navigator.currentState!
            .pushAndRemoveUntil(LoginPage.route(), (route) => false);
        break;

      case AuthStatus.initial:
      case AuthStatus.loading:
    }
  });
  return _navigator;
});

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _navigatorKey = ref.watch(topNavigatorListener);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: const SplashScreen(),
    );
  }
}
