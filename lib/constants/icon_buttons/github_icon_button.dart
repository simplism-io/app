import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GithubIconButton extends StatelessWidget {
  const GithubIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: IconButton(
        icon: const Icon(
          FontAwesomeIcons.github,
          size: 20.0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
