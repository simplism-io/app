import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../screens/root.dart';

class GoBackIconButton extends StatelessWidget {
  final bool toRoot;
  const GoBackIconButton({super.key, required this.toRoot});

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      hiddenWhen: const [Condition.largerThan(name: MOBILE)],
      child: IconButton(
        icon: const Icon(
          FontAwesomeIcons.chevronLeft,
          size: 20.0,
        ),
        onPressed: () {
          if (toRoot == true) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Root()),
                (route) => false);
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
