import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GlobalPlayerController extends GetxController {
  var url = 'http://37.247.100.104/stream';
  AudioPlayer player = AudioPlayer();

  GlobalPlayerController() {
    log("Sınıf Oluşturuldu");
  }

  playMusic() async {
    await player.setSourceUrl(url);
    await player.resume();
  }

  stopMusic() async {
    await player.pause();
  }
}
