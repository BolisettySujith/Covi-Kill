import 'package:animated_button/animated_button.dart';
import 'package:covi_kill/models/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../models/app_state.dart';
import 'music.dart';

class Settingsdialog extends StatefulWidget {
  const Settingsdialog({Key? key}) : super(key: key);

  @override
  _SettingsdialogState createState() => _SettingsdialogState();
}

class _SettingsdialogState extends State<Settingsdialog> {
  Music gameMusic = Music();
  final sharedpref = settingsState();
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
  Widget build(BuildContext context) {
    return Consumer<SettingsManager>(
        builder: (context, settingsStatus, child){
          return AnimatedButton(
            onPressed: () {
              settingsStatus.MusicStatus?gameMusic.buttonClick():"";
              settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
              setState(() {
                settingsDialog(context);
              });
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
                      radius: 0.8,
                      colors: [Color(0xFFb3471e), Color(0xFF4b2318)]
                  ),

                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.settings,
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
            shape: BoxShape.rectangle,
          );
        },
    );
  }

  Future settingsDialog(BuildContext context,) {
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
                child: Stack(children: [
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
                    // width: MediaQuery.of(context).size.height / 3,
                    decoration: kGradientBoxDecoration,
                    // color: Colors.black,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 200,
                      decoration: kInnerDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Setting",
                              style: TextStyle(
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Joy Sticks",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 20.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 30.0,
                                      )
                                    ],
                                  ).value),
                                ),
                                FlutterSwitch(
                                  inactiveIcon: const Icon(
                                    Icons.gamepad_outlined,
                                    color: Colors.grey,
                                  ),
                                  activeIcon: const Icon(
                                    Icons.gamepad,
                                    color: Colors.orange,
                                  ),
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.grey,
                                  toggleColor: Colors.white,
                                  width: ResponsiveValue(
                                  context,
                                  defaultValue: 50.0,
                                  valueWhen: const [
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 55.0,
                                    )
                                  ],
                                ).value!,
                                  height: ResponsiveValue(
                                    context,
                                    defaultValue: 26.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 31.0,
                                      )
                                    ],
                                  ).value!,
                                  toggleSize: ResponsiveValue(
                                    context,
                                    defaultValue: 24.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 29.0,
                                      )
                                    ],
                                  ).value!,
                                  // width: 55.0,
                                  // height: 31.0,
                                  // toggleSize: 29.0,
                                  value: settingsStatus.joyStickstatus,
                                  borderRadius: 28.0,
                                  padding: 0.0,
                                  switchBorder: Border.all(color: Colors.white),
                                  onToggle: (val) {
                                    settingsStatus.MusicStatus?gameMusic.switchMusic():"";
                                    settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                    Provider.of<SettingsManager>(context,listen: false).updateControllerState(val);
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Music",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 20.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 30.0,
                                      )
                                    ],
                                  ).value),
                                ),
                                FlutterSwitch(
                                  inactiveIcon: const Icon(
                                    Icons.volume_off,
                                    color: Colors.grey,
                                  ),
                                  activeIcon: const Icon(
                                    Icons.volume_up,
                                    color: Colors.orange,
                                  ),
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.grey,
                                  toggleColor: Colors.white,
                                  width: ResponsiveValue(
                                    context,
                                    defaultValue: 50.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 55.0,
                                      )
                                    ],
                                  ).value!,
                                  height: ResponsiveValue(
                                    context,
                                    defaultValue: 26.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 31.0,
                                      )
                                    ],
                                  ).value!,
                                  toggleSize: ResponsiveValue(
                                    context,
                                    defaultValue: 24.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 29.0,
                                      )
                                    ],
                                  ).value!,
                                  value: settingsStatus.MusicStatus,
                                  borderRadius: 28.0,
                                  padding: 0.0,
                                  switchBorder: Border.all(color: Colors.white),
                                  onToggle: (val) {
                                    settingsStatus.MusicStatus ? gameMusic.switchMusic():"";
                                    settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                    Provider.of<SettingsManager>(context,listen: false).updateMusicState(val);
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Vibrate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 20.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 30.0,
                                      )
                                    ],
                                  ).value),
                                ),
                                FlutterSwitch(
                                  inactiveIcon: const Icon(
                                    Icons.vibration_outlined,
                                    color: Colors.grey,
                                  ),
                                  activeIcon: const Icon(
                                    Icons.vibration,
                                    color: Colors.orange,
                                  ),
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.grey,
                                  toggleColor: Colors.white,
                                  width: ResponsiveValue(
                                    context,
                                    defaultValue: 50.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 55.0,
                                      )
                                    ],
                                  ).value!,
                                  height: ResponsiveValue(
                                    context,
                                    defaultValue: 26.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 31.0,
                                      )
                                    ],
                                  ).value!,
                                  toggleSize: ResponsiveValue(
                                    context,
                                    defaultValue: 24.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 29.0,
                                      )
                                    ],
                                  ).value!,
                                  value: settingsStatus.vibrateStatus,
                                  borderRadius: 28.0,
                                  padding: 0.0,
                                  switchBorder: Border.all(color: Colors.white),
                                  onToggle: (val) {
                                    settingsStatus.MusicStatus ? gameMusic.switchMusic():"";
                                    settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                    Provider.of<SettingsManager>(context,listen: false).updatevibrateState(val);
                                  },
                                ),
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
                      // margin: EdgeInsets.all(1),
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
                              settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                              settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "X",
                                style: TextStyle(
                                    fontSize: ResponsiveValue(
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
                                    ).value, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ),
                    top: 0,
                    right: -1,
                  ),
                ]),
              );
            },
          );
        }
      );
  }
}


