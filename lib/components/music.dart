import 'package:audioplayers/audioplayers.dart';

class Music{
  final playerS = AudioCache();

  gameEnterMusic(){
    playerS.play('audio/game_enter.wav');
  }
  giveUpMusic(){
    playerS.play('audio/give_up.wav');
  }
  void switchMusic(){
    playerS.play('audio/switch.mp3');
  }
  void failMusic(){
    playerS.play('audio/fail.wav');
  }
  void buttonClick(){
    playerS.play('audio/button_click.wav');

  }
  void winScreen(){
    playerS.play('audio/win_splace_screen.wav');
  }
  void vaccineCollctedMusic() {
    playerS.play('audio/vaccine_collected.wav');
  }
  void gameBoardMusic(){
    playerS.play('audio/TapSound.mp3');

  }

}