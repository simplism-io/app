import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class GoBackTextButton extends StatelessWidget {
  const GoBackTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft),
        onPressed: () => {
              Navigator.pop(context),
            },
        child: Text(
            LocalizationService.of(context)?.translate('go_back_link_label') ??
                ''));
  }
}
