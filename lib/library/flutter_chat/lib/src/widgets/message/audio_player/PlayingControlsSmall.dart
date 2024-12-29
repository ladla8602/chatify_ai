// ignore_for_file: file_names

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class PlayingControlsSmall extends StatelessWidget {
  final bool isPlaying;
  final LoopMode loopMode;
  final Function() onPlay;
  final Function()? onStop;
  final Function()? toggleLoop;

  const PlayingControlsSmall({
    super.key,
    required this.isPlaying,
    required this.loopMode,
    this.toggleLoop,
    required this.onPlay,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        NeumorphicRadio(
          style: const NeumorphicRadioStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: const EdgeInsets.all(12),
          value: LoopMode.single,
          groupValue: loopMode,
          onChanged: (newValue) {
            if (toggleLoop != null) toggleLoop!();
          },
          child: const Icon(
            Icons.loop,
            size: 18,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        NeumorphicButton(
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: const EdgeInsets.all(16),
          onPressed: onPlay,
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 32,
          ),
        ),
        if (onStop != null)
          NeumorphicButton(
            style: const NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(16),
            onPressed: onPlay,
            child: const Icon(
              Icons.stop,
              size: 32,
            ),
          ),
      ],
    );
  }
}
