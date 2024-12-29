// ignore_for_file: file_names

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class PlaySpeedSelector extends StatelessWidget {
  final double playSpeed;
  final Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'PlaySpeed ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                _button(0.5),
                _button(1.0),
                _button(1.5),
                _button(2.5),
                _button(3.5),
                _button(4.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(double value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: NeumorphicRadio(
        groupValue: playSpeed,
        padding: const EdgeInsets.all(12.0),
        value: value,
        style: const NeumorphicRadioStyle(
          boxShape: NeumorphicBoxShape.circle(),
        ),
        onChanged: (double? v) {
          if (v != null) onChange(v);
        },
        child: Text('x$value'),
      ),
    );
  }

  const PlaySpeedSelector({
    super.key,
    required this.playSpeed,
    required this.onChange,
  });
}
