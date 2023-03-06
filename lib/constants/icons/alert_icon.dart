import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlertIcon extends StatelessWidget {
  final double size;
  const AlertIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
        (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS)
            ? CupertinoIcons.exclamationmark_bubble
            : FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.onBackground,
        size: size);
  }
}
