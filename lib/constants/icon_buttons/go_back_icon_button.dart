import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GoBackIconButton extends StatelessWidget {
  final BuildContext inheritedContext;
  const GoBackIconButton({super.key, required this.inheritedContext});

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
          Navigator.pop(inheritedContext);
        },
      ),
    );
  }
}
