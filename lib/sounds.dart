import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

const alarm = 'sounds/alarm-clock-short-6402.mp3';

class SoundManager {
  late Soundpool pool;
  late int soundId;

  SoundManager() {
    pool = Soundpool.fromOptions(
        options: const SoundpoolOptions(streamType: StreamType.notification));
  }

  Future<int> loadSound(String soundAssetPath) async {
    soundId = await rootBundle.load(soundAssetPath).then((ByteData soundData) {
      return pool.load(soundData);
    });
    return soundId;
  }

  Future<int> playSound(int soundId) async {
    return pool.play(soundId);
  }
}
