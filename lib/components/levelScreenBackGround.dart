import 'dart:ui';
import 'package:animated_button/animated_button.dart';
import 'package:covi_kill/models/levels_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:math' as math;

import '../models/settings_manager.dart';
import '../screens/game_screen.dart';
import 'music.dart';

class LevelBackGround extends StatefulWidget {
  const LevelBackGround({Key? key}) : super(key: key);

  @override
  State<LevelBackGround> createState() => _LevelBackGroundState();
}

class _LevelBackGroundState extends State<LevelBackGround> {
  String anime = "";
  int tempClvl = 1;
  Music gameMusic = Music();

  @override
  void initState() {
    print("Level background Initstate");
    print(Provider
        .of<LevelsManager>(context, listen: false)
        .plevel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LevelsManager>(
      builder: (context, lvlStatus, child) {
        print("Level in Background");
        print(lvlStatus.plevel);
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                  width: ResponsiveValue(
                    context,
                    defaultValue: 300.0,
                    valueWhen: const [
                      Condition.smallerThan(
                        name: MOBILE,
                        value: 300.0,
                      ),
                      Condition.smallerThan(
                        name: TABLET,
                        value: 400.0,
                      ),
                      Condition.largerThan(
                        name: TABLET,
                        value: 500.0,
                      )
                    ],
                  ).value,
                  height: ResponsiveValue(
                    context,
                    defaultValue: 300.0,
                    valueWhen: const [
                      Condition.smallerThan(
                        name: MOBILE,
                        value: 300.0,
                      ),
                      Condition.smallerThan(
                        name: TABLET,
                        value: 400.0,
                      ),
                      Condition.largerThan(
                        name: TABLET,
                        value: 500.0,
                      )
                    ],
                  ).value,
                  child: const rive.RiveAnimation.asset(
                    "assets/rive_assets/levelscreenbackground.riv",
                    fit: BoxFit.cover,
                    artboard: "Sun",
                  )
              ),
            ),
            Positioned(
              bottom: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        // width : MediaQuery.of(context).size.width/2,
                        // height : MediaQuery.of(context).size.height/3,
                          width: ResponsiveValue(
                            context,
                            defaultValue: MediaQuery
                                .of(context)
                                .size
                                .width,
                            valueWhen: [
                              Condition.largerThan(
                                name: TABLET,
                                value: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2,
                              )
                            ],
                          ).value,
                          height: ResponsiveValue(
                            context,
                            defaultValue: 700.0,
                            valueWhen: const [
                              Condition.smallerThan(
                                name: MOBILE,
                                value: 700.0,
                              ),
                              Condition.smallerThan(
                                name: TABLET,
                                value: 750.0,
                              ),
                              Condition.largerThan(
                                name: TABLET,
                                value: 800.0,
                              )
                            ],
                          ).value,
                          child: const rive.RiveAnimation.asset(
                            "assets/rive_assets/levelscreenbackground.riv",
                            fit: BoxFit.fill,
                            artboard: "greenbg",
                          )
                      ),
                      ResponsiveVisibility(
                          visible: false,
                          visibleWhen: const [
                            Condition.largerThan(name: TABLET),
                          ],
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2,
                                height: ResponsiveValue(
                                  context,
                                  defaultValue: 600.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 600.0,
                                    ),
                                    Condition.smallerThan(
                                      name: TABLET,
                                      value: 700.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 800.0,
                                    )
                                  ],
                                ).value,
                                child: const rive.RiveAnimation.asset(
                                  "assets/rive_assets/levelscreenbackground.riv",
                                  fit: BoxFit.fill,
                                  artboard: "greenbg",
                                )
                            ),
                          )
                      )
                    ],
                  ),

                ],
              ),
            ),
            Positioned(
              right: 0,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        // color:Colors.black,
                        // width : MediaQuery.of(context).size.width,
                        // height : MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? MediaQuery.of(context).size.width/4.0 : MediaQuery.of(context).size.width/2.0,
                          width: ResponsiveValue(
                            context,
                            defaultValue: MediaQuery.of(context).size.width,
                            valueWhen: const [
                              Condition.largerThan(
                                name: TABLET,
                                value: 1000.0,
                              )
                            ],
                          ).value,
                          // height: 200,
                          height: ResponsiveValue(
                            context,
                            defaultValue: 300.0,
                            valueWhen: const [
                              Condition.smallerThan(
                                name: TABLET,
                                value: 200.0,
                              ),
                              Condition.smallerThan(
                                name: DESKTOP,
                                value: 300.0,
                              ),
                              Condition.largerThan(
                                name: DESKTOP,
                                value: 400.0,
                              )
                            ],
                          ).value,
                          child: const rive.RiveAnimation.asset(
                            "assets/rive_assets/levelscreenbackground.riv",
                            fit: BoxFit.fitWidth,
                            artboard: "Clouds",
                          )
                      ),
                      ResponsiveVisibility(
                        visible: false,
                        visibleWhen: const [
                          Condition.largerThan(name: TABLET),
                        ],
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Container(
                              alignment: Alignment.topCenter,
                              width: 1000,
                              height: 400,
                              child: const rive.RiveAnimation.asset(
                                "assets/rive_assets/levelscreenbackground.riv",
                                fit: BoxFit.fitWidth,
                                artboard: "Clouds",
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  ResponsiveVisibility(
                    visible: false,
                    visibleWhen: const [
                      Condition.smallerThan(name: TABLET),
                    ],
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Container(
                          alignment: Alignment.topCenter,
                          // color: Colors.black,
                          // width : MediaQuery.of(context).size.width,
                          width: ResponsiveValue(
                            context,
                            defaultValue: MediaQuery.of(context).size.width,
                            valueWhen: const [
                              Condition.largerThan(
                                name: TABLET,
                                value: 1000.0,
                              )
                            ],
                          ).value,
                          // height: 200,
                          height: ResponsiveValue(
                            context,
                            defaultValue: 300.0,
                            valueWhen: const [
                              Condition.smallerThan(
                                name: TABLET,
                                value: 200.0,
                              ),
                              Condition.smallerThan(
                                name: DESKTOP,
                                value: 300.0,
                              ),
                              Condition.largerThan(
                                name: DESKTOP,
                                value: 400.0,
                              )
                            ],
                          ).value,
                          child: const rive.RiveAnimation.asset(
                            "assets/rive_assets/levelscreenbackground.riv",
                            fit: BoxFit.fitWidth,
                            artboard: "Clouds",
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),

            MediaQuery.of(context).size.width >= 800 ? RowScreen(lvlStatus) : ColumnScreen(lvlStatus),

            Positioned(
              bottom: -575,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        // width : MediaQuery.of(context).size.width/2,
                        // height : MediaQuery.of(context).size.height/3,
                          width: ResponsiveValue(
                            context,
                            defaultValue: MediaQuery.of(context).size.width,
                            valueWhen: [
                              Condition.largerThan(
                                name: TABLET,
                                value: MediaQuery.of(context).size.width/2,
                              )
                            ],
                          ).value,
                          height: ResponsiveValue(
                            context,
                            defaultValue: 600.0,
                            valueWhen: const [
                              Condition.smallerThan(
                                name: MOBILE,
                                value: 600.0,
                              ),
                              Condition.smallerThan(
                                name: TABLET,
                                value: 700.0,
                              ),
                              Condition.largerThan(
                                name: TABLET,
                                value: 800.0,
                              )
                            ],
                          ).value,
                          child: const rive.RiveAnimation.asset(
                            "assets/rive_assets/levelscreenbackground.riv",
                            fit: BoxFit.fitWidth,
                            artboard: "greenbg",
                          )
                      ),
                      ResponsiveVisibility(
                          visible: false,
                          visibleWhen: const [
                            Condition.largerThan(name: TABLET),
                          ],
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: SizedBox(
                                width : MediaQuery.of(context).size.width/2,
                                height: ResponsiveValue(
                                  context,
                                  defaultValue: 600.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 600.0,
                                    ),
                                    Condition.smallerThan(
                                      name: TABLET,
                                      value: 700.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 800.0,
                                    )
                                  ],
                                ).value,
                                child: const rive.RiveAnimation.asset(
                                  "assets/rive_assets/levelscreenbackground.riv",
                                  fit: BoxFit.fitWidth,
                                  artboard: "greenbg",
                                )
                            ),
                          )
                      )
                    ],
                  ),
                ],
              ),
            ),


          ],
        );
      },
    );
  }

  Widget levelDetailSheet() {
    return DraggableScrollableSheet(
      initialChildSize: .25,
      minChildSize: .25,
      maxChildSize: .9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.transparent,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            controller: scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Levels", style: TextStyle(
                      fontSize: 60, fontWeight: FontWeight.bold),),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      levelListTile(1),
                      levelListTile(2),
                      levelListTile(3),
                      levelListTile(4),
                      levelListTile(5),
                      levelListTile(6),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget levelListTile(int lvl_no) {
    print("lelvel statst");
    // print(levelsStatus);
    return Consumer<SettingsManager>(
      builder: (context, settingsStatus, child) {
        return Consumer<LevelsManager>(
          builder: (context, lvlStatus, child) {
            print(lvlStatus.plevel);
            print(lvlStatus.lvlsStatus);
            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.0,
                  sigmaY: 1.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    print(lvlStatus.plevel);
                    print(lvlStatus.lvlsStatus);
                    settingsStatus.MusicStatus ? gameMusic.buttonClick() : "";
                    settingsStatus.vibrateStatus
                        ? HapticFeedback.vibrate()
                        : "";
                    ((lvlStatus.lvlsStatus[lvl_no - 1] == "1") ||
                        (lvlStatus.plevel == lvl_no)) ?
                    LevelDialog(context, (lvl_no))
                        :
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Complete Previous Levels",
                        style: TextStyle(color: Colors.black54,
                            fontWeight: FontWeight.bold),),
                      backgroundColor: Colors.lightGreenAccent,
                      elevation: 0.5,
                      dismissDirection: DismissDirection.horizontal,
                    ));
                    ;
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2.0,
                            offset: Offset(0.0, 5.0),
                          ),
                        ],
                        border: (lvlStatus.plevel == lvl_no) ? Border.all(
                          color: Colors.lightGreenAccent,
                          width: 3,
                        ) : (lvlStatus.lvlsStatus[lvl_no - 1] == "1") ? Border
                            .all(
                          color: Colors.orangeAccent,
                          width: 3,
                        ) : Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: lvlStatus.plevel == lvl_no ? [
                            Colors.black45,
                            Colors.black54,
                            Colors.lightGreenAccent
                          ] : ((lvlStatus.lvlsStatus[lvl_no - 1] == "1") ? [
                            Colors.black45,
                            Colors.black54,
                            Colors.yellow
                          ] : [Colors.black45, Colors.black54, Colors.black87]),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(
                            10))
                    ),
                    alignment: Alignment.center,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text('Level $lvl_no', style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),),
                        ),
                        Wrap(
                          children: [
                            Icon(
                              (lvlStatus.lvlsStatus[lvl_no - 1] == "1") ? Icons
                                  .star : Icons.star_border,
                              color: (lvlStatus.lvlsStatus[lvl_no - 1] == "1")
                                  ? Colors.orangeAccent
                                  : Colors.white, size: 30,),
                            Icon(
                              (lvlStatus.lvlsStatus[lvl_no - 1] == "1") ? Icons
                                  .star : Icons.star_border,
                              color: (lvlStatus.lvlsStatus[lvl_no - 1] == "1")
                                  ? Colors.orangeAccent
                                  : Colors.white, size: 30,),
                            Icon(
                              (lvlStatus.lvlsStatus[lvl_no - 1] == "1") ? Icons
                                  .star : Icons.star_border,
                              color: (lvlStatus.lvlsStatus[lvl_no - 1] == "1")
                                  ? Colors.orangeAccent
                                  : Colors.white, size: 30,),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
          colors: [
            Colors.deepOrange,
            Colors.white70,
            Colors.deepOrange,
            Colors.white70,
            Colors.deepOrange,
            Colors.white70,
            Colors.deepOrange,
            Colors.white70,
          ]
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
            builder: (context, settingsStatus, child) {
              return Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), //this right here
                child: Stack(
                    children: [
                      Container(
                        height: ResponsiveValue(
                          context,
                          defaultValue: 225.0,
                          valueWhen: const [
                            Condition.largerThan(
                              name: TABLET,
                              value: 275.0,
                            )
                          ],
                        ).value,
                        width: ResponsiveValue(
                          context,
                          defaultValue: MediaQuery.of(context).size.height / 3,
                          valueWhen: const [
                            Condition.largerThan(
                              name: TABLET,
                              value: 400.0,
                            )
                          ],
                        ).value,
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
                                Text('Level $level', style: TextStyle(
                                    fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 30.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                          name: TABLET,
                                          value: 40.0,
                                        )
                                      ],
                                    ).value,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold),),
                                const Spacer(),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Difficulty : ", style: TextStyle(
                                        fontSize: ResponsiveValue(
                                          context,
                                          defaultValue: 18.0,
                                          valueWhen: const [
                                            Condition.largerThan(
                                              name: TABLET,
                                              value: 25.0,
                                            )
                                          ],
                                        ).value,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),),
                                    Text((level) <= 2 ? "Easy" : ((level) > 2 &&
                                        (level) < 5) ? "Medium" : "Hard",
                                      style: TextStyle(fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 18.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 25.0,
                                          )
                                        ],
                                      ).value,
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
                                Text(
                                  "Inject all the vaccines",
                                  style: TextStyle(
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 20.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 25.0,
                                          )
                                        ],
                                      ).value,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedButton(
                                      onPressed: () async {
                                        settingsStatus.MusicStatus ? gameMusic
                                            .gameEnterMusic() : "";
                                        settingsStatus.vibrateStatus
                                            ? HapticFeedback.vibrate()
                                            : "";
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (
                                                BuildContext context) =>
                                                GameScreen(
                                                    currentStage: (level -
                                                        1))));
                                      },
                                      child: Container(
                                          width: 110,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors
                                                      .lightGreenAccent,
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
                                              borderRadius: BorderRadius
                                                  .circular(10)
                                          ),
                                          child: Center(
                                              child: Text(
                                                "Play",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: ResponsiveValue(
                                                      context,
                                                      defaultValue: 25.0,
                                                      valueWhen: const [
                                                        Condition.largerThan(
                                                          name: TABLET,
                                                          value: 35.0,
                                                        )
                                                      ],
                                                    ).value,
                                                    color: Colors.white),
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
                          // margin: const EdgeInsets.all(1),
                          height: ResponsiveValue(
                            context,
                            defaultValue: 35.0,
                            valueWhen: const [
                              Condition.largerThan(
                                name: TABLET,
                                value: 45.0,
                              )
                            ],
                          ).value,
                          width: ResponsiveValue(
                            context,
                            defaultValue: 35.0,
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
                          ),
                          child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  settingsStatus.MusicStatus ? gameMusic
                                      .buttonClick() : "";
                                  settingsStatus.vibrateStatus ? HapticFeedback
                                      .vibrate() : "";
                                  Navigator.of(context).pop();
                                },
                                child:Center(
                                  child: Text(
                                    "X",
                                    style: TextStyle(fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 25.0,
                                      valueWhen:[
                                        Condition.largerThan(
                                          name: TABLET,
                                          value: ResponsiveValue(
                                            context,
                                            defaultValue: 25.0,
                                            valueWhen: const [
                                              Condition.largerThan(
                                                name: TABLET,
                                                value: 30.0,
                                              )
                                            ],
                                          ).value,
                                        )
                                      ],
                                    ).value,
                                        fontWeight: FontWeight.bold),
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

  Widget RowScreen(LevelsManager lvlStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(flex: 3,),
          SizedBox(
              height: ResponsiveValue(
                context,
                defaultValue: 450.0,
                valueWhen: const [
                  Condition.smallerThan(
                    name: MOBILE,
                    value: 450.0,
                  ),
                  Condition.smallerThan(
                    name: TABLET,
                    value: 500.0,
                  ),
                  Condition.largerThan(
                    name: TABLET,
                    value: 650.0,
                  )
                ],
              ).value,
              width: ResponsiveValue(
                context,
                defaultValue: 450.0,
                valueWhen: const [
                  Condition.smallerThan(
                    name: MOBILE,
                    value: 450.0,
                  ),
                  Condition.smallerThan(
                    name: TABLET,
                    value: 500.0,
                  ),
                  Condition.largerThan(
                    name: TABLET,
                    value: 700.0,
                  )
                ],
              ).value,
              child: rive.RiveAnimation.asset(
                "assets/rive_assets/levelscreenbackground.riv",
                fit: BoxFit.cover,
                artboard: "FortAnimations",
                animations: ((lvlStatus.plevel == 5) &&
                    (lvlStatus.lvlsStatus[4] == "1")) ? ["AllDone"] : [
                  "level${lvlStatus.plevel}"
                ],
              )
          ),
          const Spacer()
        ],
      ),
        Spacer(),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Container(
            // color: Colors.black,
          alignment: Alignment.center,
          height: 800,
          width: 500,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const FittedBox(fit: BoxFit.fitWidth,child: Text("Levels", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),)),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:[
                      levelListTile(1),
                      levelListTile(2),
                      levelListTile(3),
                      levelListTile(4),
                      levelListTile(5),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        ),
        Spacer(),
      ],
    );
  }

  Widget ColumnScreen(LevelsManager lvlStatus){
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(flex: 3,),
              SizedBox(
                // width : MediaQuery.of(context).size.width,
                // height : MediaQuery.of(context).size.height/1.9,
                  height: ResponsiveValue(
                    context,
                    defaultValue: 450.0,
                    valueWhen: const [
                      Condition.smallerThan(
                        name: MOBILE,
                        value: 450.0,
                      ),
                      Condition.smallerThan(
                        name: TABLET,
                        value: 550.0,
                      ),
                      Condition.largerThan(
                        name: TABLET,
                        value: 650.0,
                      )
                    ],
                  ).value,
                  width: ResponsiveValue(
                    context,
                    defaultValue: 450.0,
                    valueWhen: const [
                      Condition.smallerThan(
                        name: MOBILE,
                        value: 450.0,
                      ),
                      Condition.smallerThan(
                        name: TABLET,
                        value: 600.0,
                      ),
                      Condition.largerThan(
                        name: TABLET,
                        value: 700.0,
                      )
                    ],
                  ).value,
                  child: rive.RiveAnimation.asset(
                    "assets/rive_assets/levelscreenbackground.riv",
                    fit: BoxFit.cover,
                    artboard: "FortAnimations",
                    animations: ((lvlStatus.plevel == 5) &&
                        (lvlStatus.lvlsStatus[4] == "1")) ? ["AllDone"] : [
                      "level${lvlStatus.plevel}"
                    ],
                  )
              ),
              const Spacer()
            ],
          ),
        ),
        levelDetailSheet()
      ],
    );
  }
}
