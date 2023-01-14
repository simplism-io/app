import 'package:base/constants/icons/chevron_left_icon.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../main.dart';

class GoBackLink extends StatelessWidget {
  final bool removeState;
  final String label;
  const GoBackLink({super.key, required this.removeState, required this.label});

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return Row(
          children: [
            TextButton.icon(
                onPressed: () async {
                  if (removeState == true) {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const App()),
                            (route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const ChevronLeftIcon(),
                label: Text(label))
          ],
        );
      }),
    );
  }
}
