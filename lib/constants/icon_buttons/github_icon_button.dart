import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/util_service.dart';

class GithubIconButton extends StatelessWidget {
  const GithubIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: true,
      hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            0.0,
            10.0,
            ResponsiveValue(context, defaultValue: 10.0, valueWhen: const [
                  Condition.smallerThan(name: TABLET, value: 10.0)
                ]).value ??
                50.0,
            0.0),
        child: IconButton(
          icon: Icon(
            FontAwesomeIcons.github,
            color: Theme.of(context).colorScheme.onBackground,
            size: 25,
          ),
          onPressed: () {
            UtilService().launchSimplismGithub();
          },
        ),
      ),
    );
  }
}
