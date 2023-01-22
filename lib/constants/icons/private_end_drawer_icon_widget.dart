import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivateEndDrawer extends StatelessWidget {
  const PrivateEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
          child: IconButton(
            icon: Icon(
                (defaultTargetPlatform == TargetPlatform.iOS ||
                        defaultTargetPlatform == TargetPlatform.macOS)
                    ? CupertinoIcons.bars
                    : FontAwesomeIcons.bars,
                color: Theme.of(context).colorScheme.onBackground),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        );
      },
    );
  }
}
