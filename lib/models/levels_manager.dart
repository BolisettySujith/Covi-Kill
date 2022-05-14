import 'package:covi_kill/models/app_state.dart';
import 'package:covi_kill/models/stages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late int presentLevel;

class LevelsManager extends ChangeNotifier{
  final sharedpref = LevelsState();
  int plevel = 1;
  List<String> lvlsStatus = ["0","0","0","0","0","0","0","0","0"];

  LevelsManager(){
    LevelSetUp();
  }

  void LevelSetUp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int plvl = (await prefs.getInt("CLevel") ?? 1);
    List<String> templvlsStatus = (await  prefs.getStringList("CurrentLevelStatus") ??["0","0","0","0","0","0","0","0","0"] );
    plevel = plvl;
    presentLevel = plvl;
    lvlsStatus = templvlsStatus;
    notifyListeners();
  }

  void incrementLevel(){
    if(plevel < stages.length){
      plevel++;
      sharedpref.SaveCurrentLevelSharedPreferences(plevel);
      notifyListeners();
    }
  }

  void updateLevelStatus(int currentLevel){
    lvlsStatus[currentLevel] = "1";
    sharedpref.SaveLevelsStatusSharedPreferences(lvlsStatus);
    notifyListeners();
  }

}