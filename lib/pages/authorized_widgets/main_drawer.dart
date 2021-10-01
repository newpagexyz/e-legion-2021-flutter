import 'package:elegionhack/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerElement extends StatelessWidget {
  const DrawerElement({Key? key, required this.callback, required this.caption})
      : super(key: key);

  final String caption;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        child: Text(caption),
        onTap: callback,
      ),
    );
  }
}

class MainDrawer extends Drawer {
  MainDrawer({Key? key}) : super(key: key);

  final items = [for (var i = 0; i < 5; i++) '$i'].toList();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Consumer(builder: (context, ref, child) {
          return DrawerElement(
              callback: () {
                ref.read(authStateNotifierProvider.notifier).logout();
              },
              caption: 'Выход');
        })
      ]),
    );
  }
}
