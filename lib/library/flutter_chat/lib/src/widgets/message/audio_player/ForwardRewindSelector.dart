// ignore_for_file: file_names

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ForwardRewindSelector extends StatelessWidget {
  final double speed;
  final Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          const Text(
            'Forward/Rewind ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _button(-2),
          _button(2.0),
        ],
      ),
    );
  }

  Widget _button(double value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NeumorphicRadio(
        groupValue: speed,
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

  const ForwardRewindSelector({
    super.key,
    required this.speed,
    required this.onChange,
  });
}
