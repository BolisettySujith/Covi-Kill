import 'dart:math';
import 'dart:ui';
import 'package:animated_button/animated_button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:covi_kill/components/levelScreenBackGround.dart';
import 'package:covi_kill/components/music.dart';
import 'package:covi_kill/models/levels_manager.dart';
import 'package:covi_kill/models/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../components/settings.dart';
import 'game_screen.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {

  List<String> anime = [];
  Random random = Random();
  int Rnum =0;
  final playerS = AudioCache();
  late int currentLevelbg;

  Music gameMusic = Music();

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    Rnum = random.nextInt(2);
    currentLevelbg = Provider.of<LevelsManager>(context,listen: false).plevel;
    print("Level background");
    print(currentLevelbg);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    super.initState();
  }


  Future<Widget> buildGamePageAsync(int level) async {
    return Future.microtask(() {
      return GameScreen(
          currentStage: (level)
      );
    });
  }

  Future LevelDialog(BuildContext context, int level) {
    final kInnerDecoration = BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(20),
    );
    final kGradientBoxDecoration = BoxDecoration(
      gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepOrange,Colors.white70,Colors.deepOrange,Colors.white70,Colors.deepOrange,Colors.white70,Colors.deepOrange,Colors.white70,]
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.black
                .withOpacity(0.2),
            offset: const Offset(1.1, 4.0),
            blurRadius: 8.0),
      ],
    );
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<SettingsManager>(
            builder: (context, settingsStatus, child){
              return Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), //this right here
                child: Stack(
                    children: [
                      Container(
                        height: 225,
                        width: MediaQuery.of(context).size.height/3,
                        decoration: kGradientBoxDecoration,
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 200,
                          decoration: kInnerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: [
                                Text('Level $level', style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold),),
                                const Spacer(),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Difficulty : ", style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),),
                                    Text((level) <= 2 ? "Easy" : ((level) > 2 &&
                                        (level) < 5) ? "Medium" : "Hard",
                                      style: TextStyle(fontSize: 18,
                                          color: (level) <= 2
                                              ? Colors.green
                                              : ((level) > 2 && (level) < 5)
                                              ? Colors
                                              .orange
                                              : Colors.red,
                                          fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                const Spacer(),
                                const Text(
                                  "Inject all the vaccines",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedButton(
                                      onPressed: () async{
                                        settingsStatus.MusicStatus ? gameMusic.gameEnterMusic():"";
                                        settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
                                        Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) => GameScreen(currentStage: (level - 1))));
                                      },
                                      child: Container(
                                          width: 110,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.lightGreenAccent,
                                                  blurRadius: 8.0,
                                                  offset: Offset(0.0, 0.0),
                                                ),
                                              ],
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.green,
                                                  Colors.lightGreen,
                                                  Colors.lightGreenAccent,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: const Center(
                                              child: Text(
                                                "Play",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                                              )
                                          )
                                      ),
                                      enabled: true,
                                      shadowDegree: ShadowDegree.dark,
                                      width: 100,
                                      height: 50,
                                      duration: 60,
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                                  settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
                                  Navigator.of(context).pop();
                                },
                                child: const Center(
                                  child: Text(
                                    "X",
                                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                        ),
                        top: 0,
                        right: -1,
                      ),
                    ]
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        bool willLeave = true;
        Navigator.popUntil(context, ModalRoute.withName("/home"));
        return willLeave;
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:  (Rnum ==1) ? [ Colors.cyanAccent,Colors.orangeAccent,Colors.lightGreen,Colors.lightGreen ] : [ Colors.black,Colors.orangeAccent,Colors.cyanAccent,Colors.lightGreen,]
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            // alignment: Alignment.center,
            children: [
              const LevelBackGround(),
              backButton(),
              settingsButton(),
            ],
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
  Widget backButton(){
    return Consumer<SettingsManager>(
      builder: (context, settingsStatus, child){
        return Positioned(
          top: 10,
          left: 10,
          child: Column(
            children: [
              AnimatedButton(
                onPressed: () {
                  settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                  settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
                  Navigator.of(context).pop();
                },
                child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 12.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                      border: Border.all(color: Colors.white70),
                      gradient: const RadialGradient(
                        radius: 0.4,
                        colors: [
                          Color(0xFFb3471e), Color(0xFF4b2318)
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.home_filled,
                        size: ResponsiveValue(
                          context,
                          defaultValue: 30.0,
                          valueWhen: const [
                            Condition.smallerThan(
                              name: MOBILE,
                              value: 30.0,
                            ),
                            Condition.smallerThan(
                              name: TABLET,
                              value: 35.0,
                            ),
                            Condition.largerThan(
                              name: TABLET,
                              value: 45.0,
                            )
                          ],
                        ).value,
                      ),
                    )),
                enabled: true,
                shadowDegree: ShadowDegree.dark,
                width: ResponsiveValue(
                  context,
                  defaultValue: 40.0,
                  valueWhen: const [
                    Condition.smallerThan(
                      name: MOBILE,
                      value: 40.0,
                    ),
                    Condition.smallerThan(
                      name: TABLET,
                      value: 50.0,
                    ),
                    Condition.largerThan(
                      name: TABLET,
                      value: 60.0,
                    )
                  ],
                ).value!,
                height:ResponsiveValue(
                  context,
                  defaultValue: 40.0,
                  valueWhen: const [
                    Condition.smallerThan(
                      name: MOBILE,
                      value: 40.0,
                    ),
                    Condition.smallerThan(
                      name: TABLET,
                      value: 50.0,
                    ),
                    Condition.largerThan(
                      name: TABLET,
                      value: 60.0,
                    )
                  ],
                ).value!,
                duration: 60,
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
            ],
          ),
        );
      },
    );
  }
}