import 'package:edge_alert/edge_alert.dart';
import 'package:elegionhack/auth/auth_model.dart';
import 'package:elegionhack/auth/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'authorized_pages/widgets/button_with_arrow.dart';

class LoginPageState {
  final TextEditingController loginController;
  final TextEditingController passwordController;
  bool isPasswordHidden;

  LoginPageState(
      {required this.loginController,
      required this.passwordController,
      required this.isPasswordHidden});

  LoginPageState.initial()
      : loginController = TextEditingController(),
        passwordController = TextEditingController(),
        isPasswordHidden = true;

  void dispose() {
    loginController.dispose();
    passwordController.dispose();
  }
}

class LoginPageChangeNotifier extends ValueNotifier<LoginPageState> {
  LoginPageChangeNotifier() : super(LoginPageState.initial());

  void togglePasswordHidden() {
    value.isPasswordHidden = !value.isPasswordHidden;
    notifyListeners();
  }

  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }
}

final loginPageInputProvider =
    ChangeNotifierProvider.autoDispose((ref) => LoginPageChangeNotifier());

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  InputDecoration _decoration(
    String caption,
  ) {
    return InputDecoration(
      filled: true,
      hintText: caption,
      isDense: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controllers = ref.watch(loginPageInputProvider).value;
    final _authNotifier = ref.watch(authStateNotifierProvider.notifier);
    final width = MediaQuery.of(context).size.width;

    ref.listen<AuthState>(authStateNotifierProvider, (value) {
      if (value.status == AuthStatus.initial && value.error != null) {
        EdgeAlert.show(context,
            title: 'Ошибка',
            description: value.error!,
            duration: EdgeAlert.LENGTH_SHORT,
            gravity: EdgeAlert.BOTTOM,
            backgroundColor: Colors.red,
            icon: Icons.error);
      }
    });

    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            const Positioned.fill(
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image(image: AssetImage('images/background.png')))),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: const [
                        Spacer(),
                        Expanded(
                          flex: 3,
                          child: Image(
                            image: AssetImage('images/logo60.png'),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.65,
                    child: TextField(
                        controller: _controllers.loginController,
                        decoration: _decoration('Логин')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: width * 0.65,
                          child: TextField(
                            controller: _controllers.passwordController,
                            enableSuggestions: false,
                            obscureText: _controllers.isPasswordHidden,
                            decoration: _decoration(
                              'Пароль',
                            ),
                          ),
                        ),
                        Positioned(
                            child: IconButton(
                              icon: (_controllers.isPasswordHidden)
                                  ? const ImageIcon(
                                      AssetImage('images/pass_visiable.png'))
                                  : const ImageIcon(
                                      AssetImage('images/pass_unvisiable.png')),
                              onPressed: () {
                                ref
                                    .read(loginPageInputProvider)
                                    .togglePasswordHidden();
                              },
                            ),
                            right: 0),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(flex: 2),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ButtonWithArrow(
                            caption: 'Вход',
                            callback: () {
                              _authNotifier.login(
                                  creds: LoginPassword(
                                      email: _controllers.loginController.text,
                                      password: _controllers
                                          .passwordController.text));
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Route route() {
    return CupertinoPageRoute(builder: (context) => const LoginPage());
  }
}
