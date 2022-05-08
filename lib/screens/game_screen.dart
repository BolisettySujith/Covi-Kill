import 'dart:typed_data';
import 'dart:io';
import 'package:animated_button/animated_button.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:covi_kill/components/music.dart';
import 'package:covi_kill/components/settings.dart';
import 'package:covi_kill/models/levels_manager.dart';
import 'package:covi_kill/models/settings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swipedetector/swipedetector.dart';
import '../components/walls.dart';
import '../models/game_intents.dart';
import 'package:rive/rive.dart' as rive;
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:joystick/joystick.dart';
import '../models/stages.dart';
import '../utils/blinking_text.dart';
import 'win_screen.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class GameScreen extends StatefulWidget {
  final int currentStage;

  const GameScreen({required this.currentStage});

  @override
  createState() => _GameScreenState(currentStage: currentStage);
}

class _GameScreenState extends State<GameScreen> {
  _GameScreenState({required this.currentStage});

  
  int currentgamestatus = 0;
  int currentSteps = 0;
  List<Widget> covidIcons = [];
  bool _showAppbar = true;
  bool _showBottombar = true;
  List<String> board = [];
  int currentStage;
  List<int> staticIndexList = [];
  List<int> bricksStartPosition = [];
  List<int> treesPositionList = [];
  List<int> foodPositionList = [];
  int playerIndex = 1;
  bool hasWon = false;
  bool endGame = false;
  var direction = 'up';
  int _hours = 0;
  int _mins = 0;
  int _secs = 0;
  var parser = EmojiParser();
  final playerS = AudioCache();
  Music gameMusic = Music();
  final screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    board = List.generate(81, (index) => '$index');
    staticIndexList = stages[currentStage].staticIndexList.sublist(0);
    bricksStartPosition = stages[currentStage].bricksStartPosition.sublist(0);
    foodPositionList = stages[currentStage].foodPositionList.sublist(0);
    treesPositionList = stages[currentStage].treesPositionList.sublist(0);
    playerIndex = stages[currentStage].playerStartIndex;
    buildBoard();
    addCovidIcons();
    
  }

  void addCovidIcons() {
    for (var i = 0; i < foodPositionList.length; i++) {
      covidIcons
          .add(Icon(Icons.coronavirus_outlined, color: Colors.white, size: 20));
    }
  }
  

  void updateCovidIcons() {
    List<Widget> NewCovidIcons = covidIcons
        .asMap()
        .entries
        .map((MapEntry map) => coviIconStatus(map.key))
        .toList();
    setState(() {
      covidIcons = NewCovidIcons;
    });
  }

  Widget coviIconStatus(int index) {
    return (index) < currentgamestatus
        ? const Icon(Icons.coronavirus, color: Colors.green, size: 30)
        : const Icon(Icons.coronavirus_outlined, color: Colors.white, size: 30);
  }

  Widget buildCovidIcons(int index) {
    return coviIconStatus(index);
  }

  void buildBoard() {
    staticIndexList.sort();
    foodPositionList.sort();
    bricksStartPosition.sort();
    treesPositionList.sort();

    for (var i = 0; i < board.length; i++) {
      if (staticIndexList.contains(i)) {
        board[i] = 'X';
      }
      if (treesPositionList.contains(i)) {
        board[i] = 'T';
      }
      if (foodPositionList.contains(i)) {
        board[i] = 'F';
      }
      if (bricksStartPosition.contains(i)) {
        board[i] = 'B';
      }
      if (i == playerIndex) {
        board[i] = 'P';
      }
    }
  }

  makeMove(BuildContext context,int moveCount, bool music, bool vibration, {bool positiveMove = true}) {
    int newplayerIndex;

    if (positiveMove) {
      newplayerIndex = playerIndex + moveCount;
    } else {
      newplayerIndex = playerIndex - moveCount;
    }
    if (board[newplayerIndex] == 'X') {
      return;
    } else if (board[newplayerIndex] == 'B') {
      currentSteps++;
      if (positiveMove) {
        if (board[newplayerIndex + moveCount] == 'X' ||
            board[newplayerIndex + moveCount] == 'B') {
          return;
        }
      } else {
        if (board[newplayerIndex - moveCount] == 'X' ||
            board[newplayerIndex - moveCount] == 'B') {
          return;
        }
      }

      setState(() {
        board[playerIndex] = '$playerIndex';
        int newBrickPosition = positiveMove
            ? newplayerIndex + moveCount
            : newplayerIndex - moveCount;
        bricksStartPosition[bricksStartPosition.indexOf(newplayerIndex)] =
            newBrickPosition;
        playerIndex = newplayerIndex;
        board[playerIndex] = 'P';
      });
      checkIfWin(context, music, vibration);
    } else {
      currentSteps++;
      setState(() {
        board[playerIndex] = '$playerIndex';
        playerIndex = newplayerIndex;
        board[playerIndex] = 'P';
      });
      checkIfWin(context, music, vibration);
    }
  }

  void moveDirection(BuildContext context, String direction, bool music, bool vibration) {
    switch (direction) {
      case 'up':
        makeMove(context, 9, music, vibration, positiveMove: false);
        break;
      case 'down':
        makeMove(context,9,music, vibration,);
        break;
      case 'left':
        makeMove(context,1, music, vibration, positiveMove: false);
        break;
      case 'right':
        makeMove(context,1,music, vibration,);
        break;
    }
  }

  void checkIfWin(BuildContext context, bool music, bool vibration) async {
    buildBoard();
    List<int> currentBrickPosition = [];
    board.asMap().forEach(
      (index, element) {
        if (element == 'B') {
          currentBrickPosition.add(index);
        }
      },
    );
    currentBrickPosition.sort();
    checkBlockStatus(currentBrickPosition, music, vibration);
    if (listEquals(currentBrickPosition, foodPositionList)) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        if(Provider.of<LevelsManager>(context,listen: false).plevel == currentStage+1){
          Provider.of<LevelsManager>(context,listen: false).incrementLevel();
          Provider.of<LevelsManager>(context,listen: false).updateLevelStatus(currentStage);
        }
        music ? gameMusic.winScreen():"";
        vibration ? HapticFeedback.vibrate() : "";
        endGame = true;
        hasWon = true;
        _showAppbar = false;
        _showBottombar = false;

      });
    }
  }


  void checkBlockStatus(List<int> block,bool music, bool vibration ) async {
    List<int> currentBrickPosition = block;
    var num = 0;
    int eq_block = 0;
    for (var i = num; i < foodPositionList.length; i++) {
      if (foodPositionList.contains(currentBrickPosition[i])) {
        eq_block++;
      }
    }
    if(currentgamestatus < eq_block){
      print("DONE DONE DONE");
      music ? gameMusic.vaccineCollctedMusic():"";
      vibration ? HapticFeedback.vibrate() : "";
      setState(() {
        currentgamestatus = eq_block;
        updateCovidIcons();
      });
    }

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

  Future giveUp(BuildContext context) {
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
                            Text(
                              'Are you sure want to give up ?',
                              style: TextStyle(
                                  fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 15.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 25.0,
                                      )
                                    ],
                                  ).value,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  // width: 50.0,
                                    child: TextButton(
                                      child: const Text('Yes'),
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.lightGreen,
                                        onSurface: Colors.grey,
                                      ),
                                      onPressed: () async {
                                        settingsStatus.MusicStatus ? gameMusic.failMusic():"";
                                        settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                        Navigator.of(context).pop();
                                        await Future.delayed(
                                            const Duration(seconds: 1))
                                        ;
                                        setState(() {
                                          endGame = true;
                                          _showBottombar = false;
                                          _showAppbar = false;
                                        }
                                        );
                                      },
                                    )),
                                const SizedBox(
                                  width: 25,
                                ),
                                SizedBox(
                                  // width: 100.0,
                                    child: TextButton(
                                      child: const Text('No'),
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.red,
                                        onSurface: Colors.grey,
                                      ),
                                      onPressed: () {
                                        settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                                        settingsStatus.vibrateStatus? HapticFeedback.vibrate() : "";
                                        Navigator.of(context).pop();
                                      },
                                    )),
                              ],
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
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(-1.0, 1.0),
                              blurRadius: 5.0),
                        ],
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
                    right: 0,
                  ),
                ]),
              );
            },
          );
        });
  }


  PreferredSizeWidget gameAppBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 200),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black, Color(0xFFca5920)]),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          width: 4,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 5,
                              width: 10,
                              color: Colors.white,
                            ),
                            Container(
                              height: 5,
                              width: 10,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          height: 25,
                          child: LiquidLinearProgressIndicator(
                            value: currentgamestatus / foodPositionList.length,
                            // Defaults to 0.5.
                            valueColor: AlwaysStoppedAnimation(
                                (((currentgamestatus / foodPositionList.length)*100) ==100) ? Colors.lightGreen: Colors.white ),
                            // Defaults to the current Theme's accentColor.
                            backgroundColor: Colors.cyan.shade300,
                            // Defaults to the current Theme's backgroundColor.
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 12.0,
                            direction: Axis.horizontal,
                            center: Text(
                              (((currentgamestatus / foodPositionList.length)*100) ==0)
                                  ? parser.emojify(':nauseated_face:')
                                  : (((currentgamestatus / foodPositionList.length)*100) >= 25) && (((currentgamestatus / foodPositionList.length)*100) <= 50)
                                  ? parser.emojify(':slightly_frowning_face:')
                                  : (((currentgamestatus / foodPositionList.length)*100) <= 75)
                                  ? parser.emojify(':slightly_smiling_face:')
                                  : parser.emojify(':smiley:'),
                            )
                          ),
                        ),
                        Container(
                          height: 8,
                          width: 5,
                          color: Colors.blue,
                        ),
                        Container(
                          height: 2,
                          width: 25,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 0.4,
                      colors: [
                        Colors.orange.shade200,
                        const Color(0xFFb64a16),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 12.0,
                        offset: Offset(0.0, 5.0),
                      ),
                    ],
                  ),
                  height: 95,
                  width: 95,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 2,
                        children: [
                          const Icon(
                            Icons.coronavirus,
                            size: 10,
                          ),
                          Text(
                            foodPositionList.length.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          Text(
                            (currentStage + 1).toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ],
                      ),
                      Text(
                        "$currentSteps",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 4,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70),
                    // color: const Color(0xFFb3471e),
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF4b2318),Color(0xFFb3471e),]
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: TweenAnimationBuilder<Duration>(
                        duration: const Duration(hours: 24),
                        tween: Tween(
                          begin: Duration.zero,
                          end: const Duration(hours: 24),
                        ),
                        onEnd: () {
                          setState(() {
                            endGame = true;
                            hasWon = false;

                          });
                        },
                        builder: (BuildContext context, Duration value,
                            Widget? child) {
                          _hours = value.inHours;
                          _mins = value.inMinutes;
                          _secs = value.inSeconds % 60;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(
                              _hours.toString().padLeft(2, '0') +
                                  ' : ' +
                                  (_mins % 60).toString().padLeft(2, '0') +
                                  ' : ' +
                                  _secs.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomNavBar() {
    return Consumer<SettingsManager>(
      builder: (context, settingsStatus, child){
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                // alignment: Alignment.center,
                // color: Colors.black,
                height: 100,
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Settingsdialog(),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.5,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ Color(0xFFca5920),Colors.black,]
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white70,),
                                color: const Color(0xFFe97238),
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0xFFb3471e), Color(0xFF4b2318)]
                                ),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                  children: covidIcons
                                      .asMap()
                                      .entries
                                      .map((MapEntry map) => buildCovidIcons(map.key))
                                      .toList()),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: AnimatedButton(
                              onPressed: () {
                                settingsStatus.MusicStatus?gameMusic.giveUpMusic():"";
                                settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                giveUp(context);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
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
                                  child: const Center(
                                    child: Icon(
                                      Icons.flag_sharp,
                                      size: 25,
                                    ),
                                  )),
                              enabled: true,
                              shadowDegree: ShadowDegree.dark,
                              width: 40,
                              height: 40,
                              duration: 60,
                              color: Colors.transparent,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: AnimatedButton(
                              onPressed: () {
                                settingsStatus.MusicStatus?gameMusic.gameEnterMusic():"";
                                settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        super.widget));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
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
                                  child: const Center(
                                    child: Icon(
                                      Icons.replay,
                                      size: 25,
                                    ),
                                  )),
                              enabled: true,
                              shadowDegree: ShadowDegree.dark,
                              width: 40,
                              height: 40,
                              duration: 60,
                              color: Colors.transparent,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsManager>(
      builder: (context, settingsStatus, child){
        return WillPopScope(
          onWillPop: () async {
            bool willLeave = false;
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ), //this right here
                    child: Stack(children: [
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.height / 3,
                        decoration: kGradientBoxDecoration,
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: 150,
                          decoration: kInnerDecoration,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Are you sure want to exit ?',
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      // width: 50.0,
                                        child: TextButton(
                                          child: const Text('Yes'),
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.lightGreen,
                                            onSurface: Colors.grey,
                                          ),
                                          onPressed: () {
                                            settingsStatus.MusicStatus ? gameMusic.failMusic():"";
                                            settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                            willLeave = true;
                                            Navigator.popUntil(context, ModalRoute.withName("/home"));
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute<void>(
                                            //     builder: (BuildContext context) =>
                                            //     const LevelsScreen(),
                                            //   ),
                                            // );
                                          },
                                        )),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    SizedBox(
                                      // width: 100.0,
                                        child: TextButton(
                                          child: const Text('No'),
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.red,
                                            onSurface: Colors.grey,
                                          ),
                                          onPressed: () {
                                            settingsStatus.MusicStatus ? gameMusic.buttonClick():"";
                                            settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                            Navigator.of(context).pop();
                                          },
                                        )),
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
                                  settingsStatus.MusicStatus?gameMusic.buttonClick():"";
                                  settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
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
                });
            return willLeave;
          },
          child: SafeArea(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      opacity: 60,
                      image: AssetImage("assets/images/DocGivingVaccine.png"),
                    )),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: _showAppbar
                      ? (MediaQuery.of(context).size.width < 1400)
                      ?
                      gameAppBar()
                      :
                      PreferredSize(
                        child: Container(
                          height: 20,
                          width: 20,
                        ),
                      preferredSize: const Size(0.0, 0.0),
                      )
                      : PreferredSize(
                        child: Container(
                          height: 20,
                          width: 20,
                        ),
                        preferredSize: const Size(0.0, 0.0),
                     ),
                  bottomNavigationBar: _showBottombar
                      ? (MediaQuery.of(context).size.width < 1400)
                      ? bottomNavBar() : Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.6),
                      )
                      : Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black.withOpacity(0.6),
                        ),
                  body: endGame
                      ? Center(
                      child: hasWon
                          ? WinScreen(
                        currentStage: currentStage,
                        stepsTaken: currentSteps,
                        hours: _hours,
                        mins: _mins,
                        secs: _secs,
                        screenshotController: screenshotController,
                      )
                          : lostScreen())
                      : Center(
                    child: Shortcuts(
                      shortcuts: {
                        LogicalKeySet(LogicalKeyboardKey.arrowUp): UpIntent(),
                        LogicalKeySet(LogicalKeyboardKey.arrowDown):
                        DownIntent(),
                        LogicalKeySet(LogicalKeyboardKey.arrowRight):
                        RightIntent(),
                        LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                        LeftIntent(),
                      },
                      child: Actions(
                        actions: {
                          UpIntent: CallbackAction<UpIntent>(
                              onInvoke: (intent) => moveDirection(context,"up",settingsStatus.MusicStatus,settingsStatus.vibrateStatus)),
                          DownIntent: CallbackAction<DownIntent>(
                              onInvoke: (intent) => moveDirection(context,"down",settingsStatus.MusicStatus,settingsStatus.vibrateStatus)),
                          RightIntent: CallbackAction<RightIntent>(
                              onInvoke: (intent) => moveDirection(context,"right",settingsStatus.MusicStatus,settingsStatus.vibrateStatus)),
                          LeftIntent: CallbackAction<LeftIntent>(
                              onInvoke: (intent) => moveDirection(context,"left",settingsStatus.MusicStatus,settingsStatus.vibrateStatus)),
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              MediaQuery.of(context).size.width > 1400 ? Positioned(
                                top: 0,
                                left: 10,
                                child: SizedBox(
                                height: 200,
                                width: 500,
                                // color: Colors.black,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: SvgPicture.asset("assets/images/Covi-Kill logo.svg",),
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                              ):Container(),
                              MediaQuery.of(context).size.width > 1400 ? Positioned(
                                top: 0,
                                right: 5,
                                child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  // color: Colors.black,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Settingsdialog(),
                                    ],
                                  ),
                                ),
                              ):Container(),
                              MediaQuery.of(context).size.width >= 1400 ? GameRowScreen(settingsStatus) : GameColumnScreen(settingsStatus),
                              settingsStatus.joyStickstatus ? JoyStick():Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget GameRowScreen(SettingsManager settingsStatus){
    return Flexible(
      flex: 1,
      child: Stack(
        children: [
          Positioned(
            bottom: 50,
            right: 50,
            child: Container(
              height: 100,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4b2318),width: 4),
                color: const Color(0xFFe97238),
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFb3471e), Color(0xFF4b2318)]
                ),
                borderRadius:
                const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Time Taken",
                    style: TextStyle( fontSize: 20),
                  ),
                  TweenAnimationBuilder<Duration>(
                      duration: const Duration(hours: 24),
                      tween: Tween(
                        begin: Duration.zero,
                        end: const Duration(hours: 24),
                      ),
                      onEnd: () {
                        setState(() {
                          endGame = true;
                          hasWon = false;

                        });
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        _hours = value.inHours;
                        _mins = value.inMinutes;
                        _secs = value.inSeconds % 60;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            _hours.toString().padLeft(2, '0') +
                                ' : ' +
                                (_mins % 60).toString().padLeft(2, '0') +
                                ' : ' +
                                _secs.toString().padLeft(2, '0'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2,),
                  Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Flexible(
                            flex:4,
                            child: Container(
                              height: 300,
                              width: 400,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF4b2318),width: 5),
                                color: const Color(0xFFe97238),
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0xFF4b2318),Color(0xFFb3471e), Color(0xFF4b2318)]
                                ),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xFF4b2318),width: 5),
                                        gradient: const RadialGradient(
                                          radius: 0.5,
                                          colors: [
                                            // Colors.orange.shade200,
                                            Color(0xFFb64a16),
                                            Color(0xFF4b2318),
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(100),
                                          bottomRight: Radius.circular(100),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFF4b2318),
                                            blurRadius: 12.0,
                                            offset: Offset(0.0, 5.0),
                                          ),
                                        ],
                                      ),
                                      height: 100,
                                      width: 150,
                                      margin:
                                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          Text(
                                            "Level ${currentStage+1}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 35),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.coronavirus,
                                                size: 15,
                                              ),
                                              Text(
                                                foodPositionList.length.toString(),
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                              const Text(
                                                "|",
                                                style: TextStyle( fontSize: 20),
                                              ),
                                              Text(
                                                (currentStage + 1).toString(),
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Moves : ",
                                          style: TextStyle( fontSize: 30),
                                        ),
                                        Text(
                                          "$currentSteps",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 35),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 10,
                                              width: 15,
                                              color: Colors.white,
                                            ),
                                            Container(
                                              height: 10,
                                              width: 15,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 170,
                                          height: 40,
                                          child: LiquidLinearProgressIndicator(
                                              value: currentgamestatus / foodPositionList.length,
                                              // Defaults to 0.5.
                                              valueColor: AlwaysStoppedAnimation(
                                                  (((currentgamestatus / foodPositionList.length)*100) ==100) ? Colors.lightGreen: Colors.white ),
                                              // Defaults to the current Theme's accentColor.
                                              backgroundColor: Colors.cyan.shade300,
                                              // Defaults to the current Theme's backgroundColor.
                                              borderColor: Colors.transparent,
                                              borderWidth: 0.0,
                                              borderRadius: 12.0,
                                              direction: Axis.horizontal,
                                              // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                              center: Text(
                                                (((currentgamestatus / foodPositionList.length)*100) ==0)
                                                    ? parser.emojify(':nauseated_face:')
                                                    : (((currentgamestatus / foodPositionList.length)*100) >= 25) && (((currentgamestatus / foodPositionList.length)*100) <= 50)
                                                    ? parser.emojify(':slightly_frowning_face:')
                                                    : (((currentgamestatus / foodPositionList.length)*100) <= 75)
                                                    ? parser.emojify(':slightly_smiling_face:')
                                                    : parser.emojify(':smiley:'),
                                                style: TextStyle(fontSize: 35),
                                              )
                                          ),
                                        ),
                                        Container(
                                          height: 16,
                                          width: 10,
                                          color: Colors.blue,
                                        ),
                                        Container(
                                          height: 4,
                                          width: 50,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 50,
                              width: 500,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  Container(
                                    color: const Color(0xFF4b2318),
                                    height: 50,
                                    width: 10,
                                  ),
                                  const Spacer(flex: 1,),
                                  Container(
                                    color: const Color(0xFF4b2318),
                                    height: 50,
                                    width: 10,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 60,
                              width: 420,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  AnimatedButton(
                                    onPressed: () {
                                      settingsStatus.MusicStatus?gameMusic.giveUpMusic():"";
                                      settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                      giveUp(context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black38,
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
                                        child: const Center(
                                          child: Icon(
                                            Icons.flag_sharp,
                                            size: 35,
                                          ),
                                        )),
                                    enabled: true,
                                    shadowDegree: ShadowDegree.dark,
                                    width: 50,
                                    height: 50,
                                    duration: 60,
                                    color: Colors.transparent,
                                    shape: BoxShape.rectangle,
                                  ),
                                  Container(
                                    height: 60,
                                    width: 250,
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFF4b2318),width: 4),
                                      color: const Color(0xFFe97238),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xFFb3471e), Color(0xFF4b2318)]
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: covidIcons
                                            .asMap()
                                            .entries
                                            .map((MapEntry map) => buildCovidIcons(map.key))
                                            .toList()),
                                  ),
                                  AnimatedButton(
                                    onPressed: () {
                                      settingsStatus.MusicStatus?gameMusic.gameEnterMusic():"";
                                      settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              super.widget));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black38,
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
                                        child: const Center(
                                          child: Icon(
                                            Icons.replay,
                                            size: 35,
                                          ),
                                        )),
                                    enabled: true,
                                    shadowDegree: ShadowDegree.dark,
                                    width: 50,
                                    height: 50,
                                    duration: 60,
                                    color: Colors.transparent,
                                    shape: BoxShape.rectangle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  const Spacer(),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 0),
                      height: 850,
                      width: 850,
                      child: AnimatedOpacity(
                        duration:
                        const Duration(milliseconds: 800),
                        curve: Curves.bounceOut,
                        opacity: hasWon ? 0 : 1,
                        child: GridView.count(
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          crossAxisCount: 9,
                          children: board.map((e) {
                            if (e == 'X') {
                              return Wall();
                            } else if (e == 'F') {
                              return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                                  decoration:
                                  const BoxDecoration(
                                    color: Colors.grey,

                                  ),
                                  child: Container(

                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          // opacity: 60,
                                          image: AssetImage("assets/images/covid_Person.png"),
                                        )
                                    ),
                                  )
                              );
                            } else if (e == 'B') {
                              return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  decoration:
                                  const BoxDecoration(
                                    color: Colors.grey,

                                  ),
                                  child: Container(

                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          // opacity: 60,
                                          image: AssetImage("assets/images/syringe.png"),
                                        )
                                    ),
                                  )
                              );
                            } else if (e == 'P') {
                              return SwipeDetector(
                                child: Focus(
                                  autofocus: true,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                                      decoration:
                                      const BoxDecoration(
                                        color: Colors.grey,

                                      ),
                                      child: Container(

                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              // opacity: 60,
                                              image: AssetImage("assets/images/male_doctor.gif"),
                                            )
                                        ),
                                      )
                                  ),
                                ),
                                onSwipeUp: () async {
                                  await settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
                                  settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                  moveDirection(context,"up",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                                },
                                onSwipeDown: () async {
                                  await settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
                                  settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                  moveDirection(context,"down",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                                },
                                onSwipeLeft: () async {
                                  await settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
                                  settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                  moveDirection(context,"left",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                                },
                                onSwipeRight: () async {

                                  await settingsStatus.MusicStatus ? gameMusic.gameBoardMusic() : "";
                                  settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                  moveDirection(context,"right",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                                },
                                swipeConfiguration: SwipeConfiguration(
                                    verticalSwipeMinVelocity:
                                    20.0,
                                    verticalSwipeMinDisplacement:
                                    20.0,
                                    verticalSwipeMaxWidthThreshold:
                                    50.0,
                                    horizontalSwipeMaxHeightThreshold:
                                    50.0,
                                    horizontalSwipeMinDisplacement:
                                    20.0,
                                    horizontalSwipeMinVelocity:
                                    20.0),
                              );
                            } else if (e == 'T') {
                              return Container(
                              );
                            } else {
                              return Container(
                                color: Colors.grey,
                              );
                            }
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1,),
            ],
          ),

        ],
      ),
    );
  }

  Widget GameColumnScreen(SettingsManager settingsStatus){
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              // color: Colors.black,
              padding: const EdgeInsets.symmetric(
                  horizontal: 4, vertical: 0),
              width: MediaQuery.of(context).size.width > 1000 ? 800 :MediaQuery.of(context).size.width > 900 ? 700 : MediaQuery.of(context).size.width >= 800 ? 600 : MediaQuery.of(context).size.width < 500 ? 450:MediaQuery.of(context).size.width < 550 ? 400:MediaQuery.of(context).size.width < 600 ? 425:MediaQuery.of(context).size.width < 650 ? 475 :MediaQuery.of(context).size.width < 700 ? 500:MediaQuery.of(context).size.width < 750 ? 525:MediaQuery.of(context).size.width <= 800 ? 450:500,
              child: AnimatedOpacity(
                duration:
                const Duration(milliseconds: 800),
                curve: Curves.bounceOut,
                opacity: hasWon ? 0 : 1,
                child: GridView.count(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisCount: 9,
                  children: board.map((e) {
                    if (e == 'X') {
                      return Wall();
                    } else if (e == 'F') {
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                          decoration:
                          const BoxDecoration(
                            color: Colors.grey,

                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  // opacity: 60,
                                  image: AssetImage("assets/images/covid_Person.png"),
                                )
                            ),
                          )
                      );
                    } else if (e == 'B') {
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                          decoration:
                          const BoxDecoration(
                            color: Colors.grey,

                          ),
                          child: Container(

                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  // opacity: 60,
                                  image: AssetImage("assets/images/syringe.png"),
                                )
                            ),
                          )
                      );
                    } else if (e == 'P') {
                      return SwipeDetector(
                        child: Focus(
                          autofocus: true,
                          child: Container(
                              // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                              decoration:
                              const BoxDecoration(
                                color: Colors.grey,

                              ),
                              child: Container(

                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      // opacity: 60,
                                      image: AssetImage("assets/images/male_doctor.gif"),
                                    )
                                ),
                              )
                          ),
                        ),
                        onSwipeUp: () async {
                          await settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
                          settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                          moveDirection(context,"up",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                        },
                        onSwipeDown: () async {
                          await settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
                          settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                          moveDirection(context,"down",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                        },
                        onSwipeLeft: () async {
                          await settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
                          settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                          moveDirection(context,"left",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                        },
                        onSwipeRight: () async {

                          await settingsStatus.MusicStatus ? gameMusic.gameBoardMusic() : "";
                          settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                          moveDirection(context,"right",settingsStatus.MusicStatus,settingsStatus.vibrateStatus);
                        },
                        swipeConfiguration: SwipeConfiguration(
                            verticalSwipeMinVelocity:
                            20.0,
                            verticalSwipeMinDisplacement:
                            20.0,
                            verticalSwipeMaxWidthThreshold:
                            50.0,
                            horizontalSwipeMaxHeightThreshold:
                            50.0,
                            horizontalSwipeMinDisplacement:
                            20.0,
                            horizontalSwipeMinVelocity:
                            20.0),
                      );
                    } else if (e == 'T') {
                      return Container();
                    } else {
                      return Container(
                        color: Colors.grey,
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget JoyStick(){
    return SizedBox(

      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<SettingsManager>(
        builder: (context, settingsStatus, child){
          return Joystick(
            backgroundColor: Colors.blueGrey.shade900,
            size: ResponsiveValue(
              context,
              defaultValue: 125.0,
              valueWhen: const [
                Condition.smallerThan(
                  name: TABLET,
                  value: 150.0,
                ),
                Condition.largerThan(
                  name: TABLET,
                  value: 200.0,
                )
              ],
            ).value!,
            isDraggable: true,
            iconColor: Colors.white,
            opacity: 0.8,
            joystickMode: JoystickModes.all,
            onLeftPressed: () {
              settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
              settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
              makeMove(context,1,settingsStatus.MusicStatus, settingsStatus.vibrateStatus, positiveMove: false);
            },
            onRightPressed: () {
              settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
              settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
              makeMove(context,1,settingsStatus.MusicStatus, settingsStatus.vibrateStatus,);
            },
            onDownPressed: () {
              settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
              settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
              makeMove(context,9,settingsStatus.MusicStatus, settingsStatus.vibrateStatus,);
            },
            onUpPressed: () {
              settingsStatus.MusicStatus?gameMusic.gameBoardMusic():"";
              settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
              makeMove(context,9, settingsStatus.MusicStatus, settingsStatus.vibrateStatus, positiveMove: false);
            },
          );
        },
      ),
    );
  }
  Widget lostScreen() {
    return Consumer<SettingsManager>(
      builder: (context, settingsStatus, child){
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), //this right here
          child: Stack(children: [
            Container(
              height: ResponsiveValue(
                context,
                defaultValue: 400.0,
                valueWhen: const [
                  Condition.smallerThan(
                    name: MOBILE,
                    value: 500.0,
                  ),
                  Condition.smallerThan(
                    name: TABLET,
                    value: 400.0,
                  ),
                  Condition.equals(
                    name: TABLET,
                    value: 400.0,
                  ),
                  Condition.largerThan(
                    name: TABLET,
                    value: 500.0,
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
                          fontWeight: FontWeight.bold,
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
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(
                        height: 10,
                      ),
                      const BlinkingText(
                        stat: 'You Failed !',
                      ),
                      Flexible(
                        flex: 10,
                        child: SizedBox(
                          // color: Colors.red,
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height / 5,
                            child: const Center(
                              child: rive.RiveAnimation.asset(
                                "assets/rive_assets/winandloose.riv",
                                fit: BoxFit.contain,
                                artboard: "LooseBoard",
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
                                "Time Taken",
                                style: TextStyle(
                                    color: Colors.grey,
                                  fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 16.0,
                                    valueWhen: const [
                                      Condition.smallerThan(
                                        name: MOBILE,
                                        value: 25.0,
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
                              const Text(" : "),
                              Wrap(
                                children: [
                                  Text(
                                    _hours == 0 ? "" : "$_hours Hrs",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 16.0,
                                        valueWhen: const [
                                          Condition.smallerThan(
                                            name: MOBILE,
                                            value: 25.0,
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
                                    _mins == 0 ? "" : "$_mins Mins",
                                    style:  TextStyle(
                                        fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 16.0,
                                        valueWhen: const [
                                          Condition.smallerThan(
                                            name: MOBILE,
                                            value: 25.0,
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
                              Text(
                                _secs == 0 ? "" : "$_secs Secs",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 16.0,
                                    valueWhen: const [
                                      Condition.smallerThan(
                                        name: MOBILE,
                                        value: 25.0,
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
                               Text(
                                "No of Moves",
                                style: TextStyle(
                                    color: Colors.grey,
                                  fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 16.0,
                                    valueWhen: const [
                                      Condition.smallerThan(
                                        name: MOBILE,
                                        value: 25.0,
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
                              const Text(" : "),
                              Text(
                                "$currentSteps",
                                style:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 16.0,
                                    valueWhen: const [
                                      Condition.smallerThan(
                                        name: MOBILE,
                                        value: 25.0,
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
                              settingsStatus.MusicStatus?gameMusic.buttonClick():"";
                              settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
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
                              settingsStatus.MusicStatus?gameMusic.buttonClick():"";
                              settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
                              Navigator.popUntil(context, ModalRoute.withName("/home"));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             HomeScreen()
                              //     )
                              // );
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
                            width: 90,
                            height: 50,
                            duration: 60,
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                          ),
                          const Spacer(),
                          AnimatedButton(
                            onPressed: () async {
                              settingsStatus.MusicStatus?gameMusic.gameEnterMusic():"";
                              settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
                              if (endGame) {
                                currentStage = currentStage;
                              }
                              setState(() {
                                endGame = false;
                                hasWon = false;
                                _showBottombar = true;
                                _showAppbar = true;
                                currentStage = currentStage;
                                board = List.generate(81, (index) => '$index');
                                staticIndexList =
                                    stages[currentStage].staticIndexList.sublist(0);
                                bricksStartPosition = stages[currentStage]
                                    .bricksStartPosition
                                    .sublist(0);
                                foodPositionList = stages[currentStage]
                                    .foodPositionList
                                    .sublist(0);
                                treesPositionList = stages[currentStage]
                                    .treesPositionList
                                    .sublist(0);
                                playerIndex = stages[currentStage].playerStartIndex;
                              });
                              setState(() {
                                buildBoard();
                              });
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
                                  child: Icon(
                                    Icons.replay,
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
                margin: EdgeInsets.all(1),
                height: 35,
                width: 35,
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
                      onTap: () {
                        settingsStatus.MusicStatus?gameMusic.buttonClick():"";
                        settingsStatus.vibrateStatus?HapticFeedback.vibrate() : "";
                        Navigator.popUntil(context, ModalRoute.withName("/home"));
                      },
                      child: const Center(
                        child: Text(
                          "X",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ),
              top: 0,
              right: 0,
            ),
          ]),
        );
      },
    );
  }
  Future saveAndShare(Uint8List bytes) async{
    final time = DateTime.now().toIso8601String().replaceAll(".", "_").replaceAll(":", "_");
    final fileName = "screenshot_$time";
    final directory = await getApplicationDocumentsDirectory();
    final imagepath = File('${directory.path}/${fileName}.png');
    imagepath.writeAsBytes(bytes);
    const text = "Test share";
    await Share.shareFiles([imagepath.path],text: text);
  }
}
