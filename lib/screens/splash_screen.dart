import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';
import 'package:loading_animations/loading_animations.dart';


class SplashScrenn extends StatefulWidget {
  const SplashScrenn({Key? key}) : super(key: key);

  @override
  _SplashScrennState createState() => _SplashScrennState();
}

class _SplashScrennState extends State<SplashScrenn> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.of(context).pushNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110524),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset("assets/app_logo.svg"),
              ],
            ),
            // SvgPicture.asset("assets/app_logo.svg"),
            const SizedBox(height: 20.0),
            // const Text(
            //   'Initializing app...',
            //   style: TextStyle(color: Colors.grey, fontSize: 20),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingBouncingGrid.circle(
                  backgroundColor: Colors.white70,
                  size: 20,
                ),
                LoadingBouncingGrid.circle(
                  backgroundColor: Colors.white70,
                  size: 25,
                ),
                LoadingBouncingGrid.circle(
                  backgroundColor: Colors.white70,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
