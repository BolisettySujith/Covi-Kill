import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:animated_button/animated_button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:covi_kill/components/music.dart';
import 'package:covi_kill/models/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rive/rive.dart' as rive;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../components/bubbles.dart';
import '../components/star_comp.dart';
import '../utils/blinking_text.dart';
import 'game_screen.dart';
import 'home.dart';

class WinScreen extends StatefulWidget {
  final int currentStage;
  final int stepsTaken;
  final int hours;
  final int mins;
  final int secs;
  final ScreenshotController screenshotController;

  const WinScreen(
      {required this.currentStage,
      required this.stepsTaken,
      required this.hours,
      required this.mins,
      required this.secs, required this.screenshotController});

  @override
  _WinScreenState createState() => _WinScreenState(
      currentStage: currentStage,
      stepsTaken: stepsTaken,
      hours: hours,
      mins: mins,
      secs: secs,
      screenshotController: screenshotController
  );
}

class _WinScreenState extends State<WinScreen>
    with SingleTickerProviderStateMixin {
  _WinScreenState(
      {
        required this.currentStage,
        required this.stepsTaken,
        required this.hours,
        required this.mins,
        required this.secs,
        required this.screenshotController
      });

  int hours;
  int mins;
  int secs;
  int stepsTaken;
  int currentStage;
  late AnimationController _controller;
  ScreenshotController screenshotController;
  bool celStatus = true;
  final playerS = AudioCache();
  Music gameMusic = Music();

  final kInnerDecoration = BoxDecoration(
    color: Colors.black87,
    borderRadius: BorderRadius.circular(20),
  );
  final kGradientBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepOrange,
          Colors.white70,
          Colors.deepOrange,
          Colors.white70,
          Colors.deepOrange,
          Colors.white70,
          Colors.deepOrange,
          Colors.white70,
        ]),
    borderRadius: BorderRadius.circular(20),
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(1.1, 4.0),
          blurRadius: 8.0),
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  startTimer() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    setState(() {
      celStatus = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Bubbles(),
          celStatus ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const BlinkingText(
                stat: 'You Won',
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Awesome',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: ResponsiveValue(
                      context,
                      defaultValue: 45.0,
                      valueWhen: const [
                        Condition.largerThan(
                          name: MOBILE,
                          value: 50.0,
                        ),
                        Condition.largerThan(
                          name: TABLET,
                          value: 60.0,
                        )
                      ],
                    ).value,
                    color: Colors.white
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Wow... You have passed this level!',
                style: TextStyle(
                    fontSize: ResponsiveValue(
                      context,
                      defaultValue: 25.0,
                      valueWhen: const [
                        Condition.largerThan(
                          name: MOBILE,
                          value: 36.0,
                        ),
                        Condition.largerThan(
                          name: TABLET,
                          value: 45.0,
                        )
                      ],
                    ).value,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: SizedBox(
                      // height: 250,
                      // width: 250,
                      height: ResponsiveValue(
                        context,
                        defaultValue: 175.0,
                        valueWhen: const [
                          Condition.largerThan(
                            name: MOBILE,
                            value: 225.0,
                          ),
                          Condition.largerThan(
                            name: TABLET,
                            value: 275.0,
                          )
                        ],
                      ).value,
                      width: ResponsiveValue(
                        context,
                        defaultValue: 175.0,
                        valueWhen: const [
                          Condition.largerThan(
                            name: MOBILE,
                            value: 225.0,
                          ),
                          Condition.largerThan(
                            name: TABLET,
                            value: 275.0,
                          )
                        ],
                      ).value,
                      child: ClipPath(
                        clipper: StarClipper(15),
                        child: Container(
                          height: 150,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _controller,
                    child: SizedBox(
                      // height: 125,
                      // width: 125,
                      height: ResponsiveValue(
                        context,
                        defaultValue: 125.0,
                        valueWhen: const [
                          Condition.largerThan(
                            name: MOBILE,
                            value: 175.0,
                          ),
                          Condition.largerThan(
                            name: TABLET,
                            value: 225.0,
                          )
                        ],
                      ).value,
                      width: ResponsiveValue(
                        context,
                        defaultValue: 125.0,
                        valueWhen: const [
                          Condition.largerThan(
                            name: MOBILE,
                            value: 175.0,
                          ),
                          Condition.largerThan(
                            name: TABLET,
                            value: 225.0,
                          )
                        ],
                      ).value,
                      child: ClipPath(
                        clipper: StarClipper(15),
                        child: Container(
                          height: 150,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: Text((currentStage + 1).toString(),
                          style: TextStyle(
                              fontSize: ResponsiveValue(
                                context,
                                defaultValue: 50.0,
                                valueWhen: const [
                                  Condition.largerThan(
                                    name: MOBILE,
                                    value: 75.0,
                                  ),
                                  Condition.largerThan(
                                    name: TABLET,
                                    value: 100.0,
                                  )
                                ],
                              ).value,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          )
          :
          Consumer<SettingsManager>(
            builder: (context, settingsStatus, child){
              return Dialog(
                backgroundColor: Colors.black.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), //this right here
                child: Stack(
                    children: [
                      Container(
                        // height: 400,
                        // width: MediaQuery.of(context).size.width,
                        height: ResponsiveValue(
                          context,
                          defaultValue: 400.0,
                          valueWhen: const [
                            Condition.smallerThan(
                              name: MOBILE,
                              value: 600.0,
                            ),
                            Condition.smallerThan(
                              name: TABLET,
                              value: 500.0,
                            ),
                            Condition.equals(
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
                          defaultValue: MediaQuery.of(context).size.height / 3,
                          valueWhen: const [

                            Condition.smallerThan(
                              name: TABLET,
                              value: 350.0,
                            ),
                            Condition.equals(
                              name: TABLET,
                              value: 350.0,
                            ),
                            Condition.largerThan(
                              name: TABLET,
                              value: 400.0,
                            )
                          ],
                        ).value,
                        decoration: kGradientBoxDecoration,
                        // color: Colors.black,
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 200,
                          decoration: kInnerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text(
                                  'Level ' + (currentStage + 1).toString(),
                                  style: TextStyle(
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 30.0,
                                        valueWhen: const [
                                          Condition.smallerThan(
                                            name: MOBILE,
                                            value: 50.0,
                                          ),
                                          Condition.largerThan(
                                            name: MOBILE,
                                            value: 40.0,
                                          ),
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 50.0,
                                          )
                                        ],
                                      ).value,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  'COMPLETED',
                                  style: TextStyle(
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 18.0,
                                        valueWhen: const [
                                          Condition.smallerThan(
                                            name: MOBILE,
                                            value: 30.0,
                                          ),
                                          Condition.largerThan(
                                            name: MOBILE,
                                            value: 40.0,
                                          ),
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 30.0,
                                          )
                                        ],
                                      ).value,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: ResponsiveValue(
                                    context,
                                    defaultValue: 3.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 8.0,
                                      )
                                    ],
                                  ).value!,
                                  children: [
                                    star(),
                                    star(),
                                    star(),
                                  ],
                                ),

                                Flexible(
                                  flex: 10,
                                  child: SizedBox(
                                    // color: Colors.red,
                                      width: MediaQuery.of(context).size.width / 1.5,
                                      height: MediaQuery.of(context).size.height / 5,
                                      child: Center(
                                        child: rive.RiveAnimation.asset(
                                          "assets/rive_assets/winandloose.riv",
                                          fit: BoxFit.contain,
                                          artboard: "Lvl" + (currentStage + 1).toString(),
                                        ),
                                      )),
                                ),
                                const Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Time Taken : ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                            fontSize: ResponsiveValue(
                                              context,
                                              defaultValue: 16.0,
                                              valueWhen: const [
                                                Condition.smallerThan(
                                                  name: MOBILE,
                                                  value: 20.0,
                                                ),
                                                Condition.largerThan(
                                                  name: MOBILE,
                                                  value: 30.0,
                                                ),
                                                Condition.largerThan(
                                                  name: TABLET,
                                                  value: 20.0,
                                                )
                                              ],
                                            ).value,
                                          ),
                                        ),
                                        Text(
                                          hours == 0 ? "" : hours <= 1 ? "$hours Hr":"$hours Hrs",
                                          style:  TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: ResponsiveValue(
                                                context,
                                                defaultValue: 16.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                    name: MOBILE,
                                                    value: 20.0,
                                                  ),
                                                  Condition.largerThan(
                                                    name: MOBILE,
                                                    value: 30.0,
                                                  ),
                                                  Condition.largerThan(
                                                    name: TABLET,
                                                    value: 20.0,
                                                  )
                                                ],
                                              ).value,
                                          ),
                                        ),
                                        Text(
                                          mins == 0 ? "" : mins <= 1 ? "$mins Min" : "$mins Mins",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: ResponsiveValue(
                                                context,
                                                defaultValue: 16.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                    name: MOBILE,
                                                    value: 20.0,
                                                  ),
                                                  Condition.largerThan(
                                                    name: MOBILE,
                                                    value: 30.0,
                                                  ),
                                                  Condition.largerThan(
                                                    name: TABLET,
                                                    value: 20.0,
                                                  )
                                                ],
                                              ).value,
                                          ),
                                        ),
                                        Text(
                                          secs == 0 ? "" : secs <= 1 ? "$secs Sec" : "$secs Secs",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveValue(
                                              context,
                                              defaultValue: 16.0,
                                              valueWhen: const [
                                                Condition.smallerThan(
                                                  name: MOBILE,
                                                  value: 20.0,
                                                ),
                                                Condition.largerThan(
                                                  name: MOBILE,
                                                  value: 30.0,
                                                ),
                                                Condition.largerThan(
                                                  name: TABLET,
                                                  value: 20.0,
                                                )
                                              ],
                                            ).value,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("No of Moves : ",
                                            style: TextStyle(color: Colors.grey,
                                              fontSize: ResponsiveValue(
                                                context,
                                                defaultValue: 16.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                    name: MOBILE,
                                                    value: 20.0,
                                                  ),
                                                  Condition.largerThan(
                                                    name: MOBILE,
                                                    value: 30.0,
                                                  ),
                                                  Condition.largerThan(
                                                    name: TABLET,
                                                    value: 20.0,
                                                  )
                                                ],
                                              ).value,
                                            ),
                                        ),
                                        Text(
                                          "$stepsTaken",
                                          style:  TextStyle(
                                              fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveValue(
                                              context,
                                              defaultValue: 16.0,
                                              valueWhen: const [
                                                Condition.smallerThan(
                                                  name: MOBILE,
                                                  value: 20.0,
                                                ),
                                                Condition.largerThan(
                                                  name: MOBILE,
                                                  value: 30.0,
                                                ),
                                                Condition.largerThan(
                                                  name: TABLET,
                                                  value: 20.0,
                                                )
                                              ],
                                            ).value,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    AnimatedButton(
                                      onPressed: () async {
                                        await settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                                        await settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                        final image = await screenshotController.capture();
                                        if(image == null) return;
                                        await saveAndShare(image);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.orange,
                                                  blurRadius: 8.0,
                                                  offset: Offset(0.0, 0.0),
                                                ),
                                              ],
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.orange,
                                                  Colors.orangeAccent,
                                                  Colors.deepOrange,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: const Center(
                                            child: Icon(
                                              Icons.share,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          )),
                                      enabled: true,
                                      shadowDegree: ShadowDegree.dark,
                                      width: 50,
                                      height: 50,
                                      duration: 60,
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    const Spacer(),
                                    AnimatedButton(
                                      onPressed: () async {
                                        await settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                                        await settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                        Navigator.popUntil(context, ModalRoute.withName("/home"));
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (BuildContext context) =>
                                        //         const HomeScreen()));
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.cyan,
                                                  blurRadius: 8.0,
                                                  offset: Offset(0.0, 0.0),
                                                ),
                                              ],
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.blue,
                                                  Colors.lightBlueAccent,
                                                  Colors.cyan,
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: const Center(
                                            child: Icon(
                                              Icons.home,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          )),
                                      enabled: true,
                                      shadowDegree: ShadowDegree.dark,
                                      width: 50,
                                      height: 50,
                                      duration: 60,
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    const Spacer(),
                                    AnimatedButton(
                                      onPressed: () async {
                                        await settingsStatus.MusicStatus ? gameMusic.gameEnterMusic() : "";
                                        await settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    GameScreen(
                                                        currentStage:
                                                        (currentStage + 1))));
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
                                              borderRadius: BorderRadius.circular(10)),
                                          child: const Center(
                                              child: Text(
                                                "Next",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: Colors.white),
                                              ))),
                                      enabled: true,
                                      shadowDegree: ShadowDegree.dark,
                                      width: 100,
                                      height: 50,
                                      duration: 60,
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          // margin: const EdgeInsets.all(1),
                          height: ResponsiveValue(
                            context,
                            defaultValue: 45.0,
                            valueWhen: const [
                              Condition.largerThan(
                                name: TABLET,
                                value: 45.0,
                              )
                            ],
                          ).value,
                          width: ResponsiveValue(
                            context,
                            defaultValue: 45.0,
                            valueWhen: const [
                              Condition.largerThan(
                                name: TABLET,
                                value: 45.0,
                              )
                            ],
                          ).value,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(-1.0, 1.0),
                                  blurRadius: 5.0),
                            ],
                          ),
                          child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  await settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                                  await settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                  Navigator.popUntil(context, ModalRoute.withName("/home"));
                                },
                                child: Center(
                                  child: Text(
                                    "X",
                                    style: TextStyle(
                                        fontSize: ResponsiveValue(
                                          context,
                                          defaultValue: 30.0,
                                          valueWhen:[
                                            const Condition.largerThan(
                                              name: TABLET,
                                              value: 30.0
                                            )
                                          ],
                                        ).value, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ),
                        ),
                        top: 0,
                        right: 0,
                      ),
                    ]),
              );
            },
          )

        ],
      ),
    );
  }

  Widget star() {
    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        height: ResponsiveValue(
          context,
          defaultValue: 55.0,
          valueWhen: const [
            Condition.smallerThan(
              name: MOBILE,
              value: 80.0,
            ),
            Condition.smallerThan(
              name: TABLET,
              value: 60.0,
            ),
            Condition.equals(
              name: TABLET,
              value: 62.0,
            ),
            Condition.largerThan(
              name: TABLET,
              value: 65.0,
            )
          ],
        ).value,
        width: ResponsiveValue(
          context,
          defaultValue: 55.0,
          valueWhen: const [
            Condition.smallerThan(
              name: MOBILE,
              value: 80.0,
            ),
            Condition.smallerThan(
              name: TABLET,
              value: 60.0,
            ),
            Condition.equals(
              name: TABLET,
              value: 62.0,
            ),
            Condition.largerThan(
              name: TABLET,
              value: 65.0,
            )
          ],
        ).value,
        child: ClipPath(
          clipper: StarClipper(6),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.yellow,
                  Colors.yellow.shade700,
                  Colors.yellowAccent,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async{
    final time = DateTime.now().toIso8601String().replaceAll(".", "_").replaceAll(":", "_");
    final fileName = "screenshot_$time";
    final directory = await getApplicationDocumentsDirectory();
    final imagepath = File('${directory.path}/${fileName}.png');
    imagepath.writeAsBytes(bytes);
    var text = "🎉 🎉 Congratulation for completing level ${currentStage+1} in Covi Kill 🎉 🎉"
        " #flutter #flutterpuzzlehack #2dgames #covikill";
    await Share.shareFiles([imagepath.path],text: text);

  }
}
