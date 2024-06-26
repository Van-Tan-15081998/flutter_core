import 'package:audioplayers/audioplayers.dart';

class CommonAudioOnPressButton {
  final audioPlayer = AudioPlayer();

  Future<bool> playAudioOnPress() async {
    await stop();
    await audioPlayer.play(AssetSource('audio/click-button.mp3'), volume: 0.5);

    return true;
  }

  void dispose() {
    audioPlayer.dispose();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }

  void playAudioOnNotification() async {
    await stop();
    await audioPlayer.play(AssetSource('audio/message-notification.mp3'),
        volume: 0.5);
  }

  void playAudioOnOpenPopup() async {
    await stop();
    await audioPlayer.play(AssetSource('audio/open-popup.mp3'), volume: 0.5);
  }

  void playAudioOnFavourite() async {
    await stop();
    await audioPlayer.play(AssetSource('audio/minimal-pop-click.mp3'),
        volume: 0.5);
  }

  void playAudioOnMessage() async {
    await stop();
    await audioPlayer.play(AssetSource('audio/message-incoming.mp3'),
        volume: 0.5);
  }
}
