import 'package:elegionhack/pages/authorized_widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class AuthorizedPage extends StatelessWidget {
  const AuthorizedPage({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(drawer: const MainDrawer(), body: child));
  }

  static Route route({required Widget child}) {
    return MaterialPageRoute(
        builder: (context) => AuthorizedPage(child: child));
  }
}
