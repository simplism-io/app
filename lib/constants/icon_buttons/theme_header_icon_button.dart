import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;

import '../../services/theme_service.dart';

class ThemeHeaderIconButton extends StatelessWidget {
  const ThemeHeaderIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<ThemeService>(
        builder: (context, theme, child) => theme.darkTheme == true
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: IconButton(
                    icon: Icon(
                      (defaultTargetPlatform == TargetPlatform.iOS ||
                              defaultTargetPlatform == TargetPlatform.macOS)
                          ? CupertinoIcons.sun_max
                          : FontAwesomeIcons.sun,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () => theme.toggleTheme()),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: IconButton(
                    icon: Icon(
                      (defaultTargetPlatform == TargetPlatform.iOS ||
                              defaultTargetPlatform == TargetPlatform.macOS)
                          ? CupertinoIcons.moon
                          : FontAwesomeIcons.moon,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 25,
                    ),
                    onPressed: () => theme.toggleTheme()),
              ));
  }
}
