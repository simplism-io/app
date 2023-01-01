import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';
import '../screens/private/update_password_screen_widget..dart';

class UpdatePasswordLinkWidget extends StatelessWidget {
  final dynamic agent;
  const UpdatePasswordLinkWidget({super.key, this.agent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 300.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(LocalizationService.of(context)
                      ?.translate('update_password_button_label') ??
                  ''),
            ),
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UpdatePasswordScreenWidget(agent: agent),
                  ))
                }));
  }
}
