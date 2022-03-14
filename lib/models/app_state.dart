import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LevelsState{
  late SharedPreferences sPrefs;
  Future<void> SaveCurrentLevelSharedPreferences(int Curlevel) async{
    sPrefs = await SharedPreferences.getInstance();
    await sPrefs.setInt("CLevel", Curlevel);
  }

  Future<void> SaveLevelsStatusSharedPreferences(List<String> ClevelsState) async{
    sPrefs = await SharedPreferences.getInstance();
    await sPrefs.setStringList("CurrentLevelStatus", ClevelsState);
  }

}
class settingsState{
  late SharedPreferences sPrefs;
  Future<void> SaveCurrentVolumeStatusSharedPreferences(bool CurvolStat) async{
    sPrefs = await SharedPreferences.getInstance();
    await sPrefs.setBool("CVStat", CurvolStat);
  }
  Future<void> SaveCurrentControllerStatusSharedPreferences(bool CurControllerStat) async{
    sPrefs = await SharedPreferences.getInstance();
    await sPrefs.setBool("CCStat", CurControllerStat);
  }
  Future<void> SaveCurrentVibrationStatusSharedPreferences(bool CurVibrationStat) async{
    sPrefs = await SharedPreferences.getInstance();
    await sPrefs.setBool("CVibStat", CurVibrationStat);
  }

}