import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Waveform {
  RiveAnimationController _controller;

  // Returns the data of the animation from assets folder.
  Future<Artboard> board() async {
    var data = await rootBundle.load("assets/waveform.riv");
    final file = RiveFile();
    var artboard;

    if (file.import(data)) {
      artboard = file.mainArtboard;

      // Utilizes [Quiet Animation] for waveform.
      // There is also another animation called [Loud Animation].
      artboard.addController(_controller = SimpleAnimation("Quiet Animation"));
    }

    return artboard;
  }

  void togglePlay(bool state) {
    if (_controller != null) {
      _controller.isActive = state;
    }
  }

  bool isPlaying() {
    if (_controller != null) {
      return _controller.isActive;
    } else {
      return false;
    }
  }
}
