import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';

class SettingsManager extends ChangeNotifier{
  final sharedpref = settingsState();

  bool joyStickstatus = false;
  bool MusicStatus = true;
  bool vibrateStatus = true;

  SettingsManager(){
    setUp();
  }

  void setUp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool joyS = (await prefs.getBool("CCStat") ?? false);
    bool musicS = (await prefs.getBool("CVStat") ?? true);
    bool vibrationS = (await prefs.getBool("CVibStat") ?? true);
    joyStickstatus = joyS;
    MusicStatus = musicS;
    vibrateStatus = vibrationS;
    notifyListeners();
  }
  void updateControllerState(bool val) {
    joyStickstatus = val;
    sharedpref.SaveCurrentControllerStatusSharedPreferences(val);
    notifyListeners();
  }
  void updateMusicState(bool val) {
    MusicStatus= val;
    sharedpref.SaveCurrentVolumeStatusSharedPreferences(val);
    notifyListeners();
  }
  void updatevibrateState(bool val) {
    vibrateStatus = val;
    sharedpref.SaveCurrentVibrationStatusSharedPreferences(val);
    notifyListeners();
  }
}