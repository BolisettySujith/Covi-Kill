import 'package:flutter/material.dart';

class EarthAnimation extends StatefulWidget {
  const EarthAnimation({Key? key}) : super(key: key);

  @override
  _EarthAnimationState createState() => _EarthAnimationState();
}

class _EarthAnimationState extends State<EarthAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 30))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/DocOnGlobe.png"),
            )),
      ),
    );
  }
}
