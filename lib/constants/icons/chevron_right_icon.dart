import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChevronRightIcon extends StatelessWidget {
  const ChevronRightIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Icon(
            (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.macOS)
                ? CupertinoIcons.chevron_right
                : FontAwesomeIcons.chevronRight,
            color: Theme.of(context).colorScheme.onBackground,
            size: 15));
  }
}
