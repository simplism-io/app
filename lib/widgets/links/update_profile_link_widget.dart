import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';
import '../screens/private/update_profile_screen_widget.dart';

class UpdateProfileLinkWidget extends StatelessWidget {
  final dynamic agent;
  final Uint8List? avatarBytes;
  const UpdateProfileLinkWidget({super.key, this.agent, this.avatarBytes});

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
                      ?.translate('update_profile_button_label') ??
                  ''),
            ),
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateProfileScreenWidget(
                        agent: agent, avatarBytes: avatarBytes),
                  ))
                }));
  }
}
