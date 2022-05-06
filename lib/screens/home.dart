import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:covi_kill/components/home_back_ground.dart';
import 'package:covi_kill/components/music.dart';
import 'package:covi_kill/models/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:animated_button/animated_button.dart';
import '../components/earth_rotateting_animation.dart';
import '../components/settings.dart';
import '../models/levels_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final levelBlc = LevelsBloc();
  final playerS = AudioCache();
  Music gameMusic = Music();
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    super.initState();
  }

  @override
  void dispose() {
    // levelBlc.dispose();
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        },
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black,Colors.cyanAccent, Colors.orange]
              )
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child:Stack(
                alignment: Alignment.center,
                children: [
                  const HomeBackGround(),
                  Positioned(
                    bottom: ResponsiveValue(
                      context,
                      defaultValue: -210.0,
                      valueWhen: const [
                        Condition.smallerThan(
                          name: MOBILE,
                          value: -210.0,
                        ),
                        Condition.smallerThan(
                          name: TABLET,
                          value: -260.0,
                        ),
                        Condition.largerThan(
                          name: TABLET,
                          value: -310.0,
                        )
                      ],
                    ).value,
                    height: ResponsiveValue(
                      context,
                      defaultValue: 400.0,
                      valueWhen: const [
                        Condition.smallerThan(
                          name: MOBILE,
                          value: 400.0,
                        ),
                        Condition.smallerThan(
                          name: TABLET,
                          value: 500.0,
                        ),
                        Condition.largerThan(
                          name: TABLET,
                          value: 600.0,
                        )
                      ],
                    ).value,
                    width: ResponsiveValue(
                      context,
                      defaultValue: 500.0,
                      valueWhen: const [
                        Condition.smallerThan(
                          name: MOBILE,
                          value: 400.0,
                        ),
                        Condition.smallerThan(
                          name: TABLET,
                          value: 500.0,
                        ),
                        Condition.largerThan(
                          name: TABLET,
                          value: 600.0,
                        )
                      ],
                    ).value,
                    child: const EarthAnimation(),
                  ),
                  Positioned(
                    bottom: 50,
                    child: Consumer<LevelsManager>(
                      builder: (context, lvlState, child){
                        print("Level in Home");
                        print(lvlState.plevel);
                        return Consumer<SettingsManager>(
                          builder: (context, settingsStatus, child){
                            return AnimatedButton(
                              onPressed: () async {
                                settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                                settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
                                Navigator.of(context).pushNamed("/level");
                              },
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width:2
                                    ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 12.0,
                                          offset: Offset(0.0, 5.0),
                                        ),
                                      ],
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF388E3C),
                                          Colors.lightGreen,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(60)
                                  ),
                                  child: const Center(
                                      child: Text(
                                        "Start",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
                                      )
                                  )
                              ),
                              enabled: true,
                              shadowDegree: ShadowDegree.dark,
                              width: 110,
                              height: 60,
                              duration: 60,
                              color: Colors.transparent,
                              shape: BoxShape.rectangle,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  settingsButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget settingsButton() {
    return const Positioned(
      bottom: 10,
      left: 10,
      child: Settingsdialog(),
    );
  }
}