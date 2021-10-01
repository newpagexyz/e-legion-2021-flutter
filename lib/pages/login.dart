import 'package:edge_alert/edge_alert.dart';
import 'package:elegionhack/auth/auth_model.dart';
import 'package:elegionhack/auth/auth_provider.dart';
import 'package:elegionhack/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPageState {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    loginController.dispose();
    passwordController.dispose();
  }
}

final loginPageInputProvider = Provider.autoDispose((ref) {
  final state = LoginPageState();

  ref.onDispose(() => state.dispose());
  return state;
});

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  InputDecoration _decoration(String caption) {
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
    final _controllers = ref.watch(loginPageInputProvider);
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
                  child: SizedBox(
                    width: width * 0.65,
                    child: TextField(
                      controller: _controllers.passwordController,
                      decoration: _decoration('Пароль'),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(flex: 2),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: LoginPageAuthButton(
                          loginCallback: () {
                            _authNotifier.login(
                                creds: LoginPassword(
                                    email: _controllers.loginController.text,
                                    password:
                                        _controllers.passwordController.text));
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
    );
  }

  static Route route() {
    return CupertinoPageRoute(builder: (context) => const LoginPage());
  }
}

class LoginPageAuthButton extends StatefulWidget {
  const LoginPageAuthButton({Key? key, required this.loginCallback})
      : super(key: key);
  final VoidCallback loginCallback;
  @override
  _LoginPageAuthButtonState createState() => _LoginPageAuthButtonState();
}

class _LoginPageAuthButtonState extends State<LoginPageAuthButton>
    with SingleTickerProviderStateMixin {
  late final Animation<double> animation;
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    Tween<double> animationTween = Tween(
      begin: 0.6,
      end: 1,
    );
    animation = animationTween.animate(
      controller,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.loginCallback();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width * 0.2;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPaint(
              painter: ButtonArrowPainter(animation.value, fullWidth),
            ),
          ),
          const Text(
            'Вход',
            style: TextStyle(color: ELegionColors.eLegionLightBlue),
          )
        ],
      ),
      onTapUp: (details) {
        controller.reverse();
      },
      onTapDown: (details) {
        controller.forward();
      },
      onTapCancel: () {
        controller.reverse();
      },
    );
  }
}

class ButtonArrowPainter extends CustomPainter {
  final double end;
  final double fullWidth;
  ButtonArrowPainter(this.end, this.fullWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ELegionColors.eLegionLightBlue
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = const Offset(
      0,
      0,
    );
    final endPointX = fullWidth * end;
    Offset endingPoint = Offset(endPointX, 0);
    final bottomEndingPoint = Offset(endPointX - 5, -5);
    final topEndingPoint = Offset(endPointX - 5, 5);

    canvas.drawLine(startingPoint, endingPoint, paint);
    canvas.drawLine(endingPoint, bottomEndingPoint, paint);
    canvas.drawLine(endingPoint, topEndingPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
