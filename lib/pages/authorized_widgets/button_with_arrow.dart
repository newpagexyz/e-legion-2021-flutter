import 'dart:ui';

import 'package:elegionhack/colors.dart';
import 'package:flutter/material.dart';

class ButtonWithArrow extends StatefulWidget {
  const ButtonWithArrow(
      {Key? key,
      required this.callback,
      required this.caption,
      this.horizontal = false})
      : super(key: key);
  final VoidCallback callback;
  final String caption;
  final bool horizontal;
  @override
  _ButtonWithArrowState createState() => _ButtonWithArrowState();
}

class _ButtonWithArrowState extends State<ButtonWithArrow>
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
          widget.callback();
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
    final children = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomPaint(
            painter: ButtonArrowPainter(animation.value, fullWidth,
                caption: widget.caption, horizontal: widget.horizontal)),
      ),
      Text(
        widget.caption,
        style: const TextStyle(color: ELegionColors.eLegionLightBlue),
      )
    ];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: widget.horizontal
            ? Row(
                children: children,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children),
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
  final bool horizontal;
  final String caption;
  ButtonArrowPainter(this.end, this.fullWidth,
      {required this.horizontal, required this.caption});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ELegionColors.eLegionLightBlue
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = horizontal
        ? const Offset(100, 0)
        : const Offset(
            0,
            0,
          );
    final endPointX = fullWidth * end + (horizontal ? 100 : 0);
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
