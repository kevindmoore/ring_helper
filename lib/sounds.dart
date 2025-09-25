import 'package:audioplayers/audioplayers.dart';

const alarm = 'alarm-clock-short-6402.mp3';

class SoundManager {
  late AudioPlayer player;
  late int soundId;

  SoundManager() {
    player = AudioPlayer();
  }

  // Future<int> loadSound(String soundAssetPath) async {
  //   player.open(Audio(soundAssetPath), autoStart: false);
  //   // soundId = await rootBundle.load(soundAssetPath).then((ByteData soundData) {
  //   //   return player.open(Audio(soundData);
  //   // });
  //   // return soundId;
  // }

  Future playSound(String soundAssetPath) async {
    await player.play(AssetSource(soundAssetPath));
  }
  // Future<int> playSound(int soundId) async {
  //   return player.play(soundId);
  // }
}
