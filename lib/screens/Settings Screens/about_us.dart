import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/music.dart';
import '../../models/settings_manager.dart';

class AboutUs extends StatelessWidget {
  AboutUs({Key? key}) : super(key: key);
  Music gameMusic = Music();
  @override
  Widget build(BuildContext context) {
    return Container();
  }
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

  Future about_us_dialog(BuildContext context) {
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
                      defaultValue: 150.0,
                      valueWhen: const [
                        Condition.largerThan(
                          name: TABLET,
                          value: 250.0,
                        )
                      ],
                    ).value,
                    width:ResponsiveValue(
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
                    // color: Colors.black,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 150,
                      decoration: kInnerDecoration,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(
                                    children: [
                                      // TextSpan(
                                      //   text: "Game developer :",
                                      //   style: TextStyle(
                                      //     fontSize: ResponsiveValue(
                                      //       context,
                                      //       defaultValue: 15.0,
                                      //       valueWhen: const [
                                      //         Condition.largerThan(
                                      //           name: TABLET,
                                      //           value: 25.0,
                                      //         )
                                      //       ],
                                      //     ).value,
                                      //   ),
                                      // ),
                                      // TextSpan(
                                      //     text: "Website",
                                      //     style: TextStyle(
                                      //       fontSize: ResponsiveValue(
                                      //         context,
                                      //         defaultValue: 15.0,
                                      //         valueWhen: const [
                                      //           Condition.largerThan(
                                      //             name: TABLET,
                                      //             value: 25.0,
                                      //           )
                                      //         ],
                                      //       ).value,
                                      //     ),
                                      //     recognizer: TapGestureRecognizer()
                                      //       ..onTap = () {
                                      //         launch("https://bolisettysujith.rocks");
                                      //       }
                                      // )
                                    ]
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.all(1),
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
                              settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text(
                                "X",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
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
        });
  }
}
