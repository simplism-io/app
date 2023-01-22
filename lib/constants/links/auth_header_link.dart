import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../screens/public/auth_screen.dart';
import '../../services/localization_service.dart';

class AuthLink extends StatelessWidget {
  const AuthLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(
            20.0,
            10.0,
            ResponsiveValue(context, defaultValue: 50.0, valueWhen: const [
                  Condition.smallerThan(name: TABLET, value: 10.0)
                ]).value ??
                50.0,
            0.0),
        child: TextButton.icon(
          icon: Icon(
              (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.macOS)
                  ? CupertinoIcons.folder
                  : FontAwesomeIcons.inbox,
              color:
                  Theme.of(context).colorScheme.onBackground), // Your icon here
          label: Text(
            LocalizationService.of(context)?.translate('inbox_header_label') ??
                '',
            style: TextStyle(
                fontSize: ResponsiveValue(context,
                    defaultValue: 15.0,
                    valueWhen: const [
                      Condition.smallerThan(name: DESKTOP, value: 15.0)
                    ]).value,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground),
          ), // Your text here
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false);
          },
        ));
  }
}
