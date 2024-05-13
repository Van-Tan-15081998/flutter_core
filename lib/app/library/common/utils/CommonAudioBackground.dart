import 'package:audioplayers/audioplayers.dart';

class CommonAudioBackground {
  final audioPlayer = AudioPlayer();

  /*
  CommonAudioBackground.backgroundMusicList()
   */
  static List<String> backgroundMusicList() {
    List<String> backgroundMusicList = [
      'audio/background_musics/The_Best_Time.mp3',
      'audio/background_musics/Best_Time.mp3',
      'audio/background_musics/NostalgicWaltz.mp3',
      'audio/background_musics/BossaNova.mp3',
      'audio/background_musics/Ciudades.mp3',
      'audio/background_musics/DreamOfSummer.mp3',
      'audio/background_musics/FeelBossaNova.mp3'
    ];

    return backgroundMusicList;
  }

  void playBackgroundMusic() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(
        AssetSource('audio/background_musics/The_Best_Time.mp3'),
        volume: 0.5);
  }

  void play({required String url, bool? isLoop}) async {
    await stop();
    if (isLoop == true) {
      audioPlayer.setReleaseMode(ReleaseMode.loop);
    }
    await audioPlayer.play(
      AssetSource(url),
      volume: 1,
    );
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }

  void pause() {
    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.pause();
    }
  }

  void resume() {
    if (audioPlayer.state == PlayerState.paused) {
      audioPlayer.resume();
    }
  }

  void dispose() {
    audioPlayer.dispose();
  }

  void playList() async {
    await stop();
    int currentIndex = 0;

    play(url: CommonAudioBackground.backgroundMusicList()[currentIndex]);

    audioPlayer.onPlayerComplete.listen((event) {
      if (currentIndex <
          CommonAudioBackground.backgroundMusicList().length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      play(url: CommonAudioBackground.backgroundMusicList()[currentIndex]);
    });
  }
}
