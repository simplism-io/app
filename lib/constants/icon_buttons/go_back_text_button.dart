import 'package:flutter/material.dart';

import '../../screens/root.dart';
import '../../services/localization_service.dart';

class GoBackTextButton extends StatelessWidget {
  final bool toRoot;
  const GoBackTextButton({super.key, required this.toRoot});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft),
        onPressed: () => {
              if (toRoot == true)
                {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Root()),
                      (route) => false)
                }
              else
                {Navigator.pop(context)}
            },
        child: Text(
            LocalizationService.of(context)?.translate('go_back_link_label') ??
                ''));
  }
}
