import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager extends Component {
  bool musicEnabled = true;
  bool soundsEnabled = true;

  final List<String> _sounds = [
    'click',
    'collect',
    'explode1',
    'explode2',
    'fire',
    'hit',
    'laser',
    'start',
  ];

  final Map<String, AudioPlayer> _soundPlayers = {};

  @override
  FutureOr<void> onLoad() async {
    FlameAudio.bgm.initialize();

    // Pre-initialize audio players for sound effects
    for (String sound in _sounds) {
      _soundPlayers[sound] = AudioPlayer();
      await _soundPlayers[sound]!.setSource(AssetSource('audio/$sound.ogg'));
    }

    return super.onLoad();
  }

  void playMusic() {
    if (musicEnabled) {
      FlameAudio.bgm.play('music.ogg');
    }
  }

  void playSound(String sound) async {
    if (soundsEnabled && _soundPlayers.containsKey(sound)) {
      await _soundPlayers[sound]!.stop(); // Stop any previous instance
      await _soundPlayers[sound]!.resume(); // Play the sound
    }
  }

  void toggleMusic() {
    musicEnabled = !musicEnabled;
    if (musicEnabled) {
      playMusic();
    } else {
      FlameAudio.bgm.stop();
    }
  }

  void toggleSounds() {
    soundsEnabled = !soundsEnabled;
  }

  @override
  void onRemove() {
    // Clean up audio players
    for (AudioPlayer player in _soundPlayers.values) {
      player.dispose();
    }
    super.onRemove();
  }
}
