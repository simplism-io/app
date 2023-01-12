import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';
import '../../services/agent_service.dart';
import '../../services/snackbar_service.dart';

class SignInWithGoogleButtonWidget extends StatelessWidget {
  const SignInWithGoogleButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? CupertinoButton(
              onPressed: () async {
                try {
                  AgentService().signInUsingGoogle();
                } catch (e) {
                  SnackBarService()
                      .errorSnackBar('general_error_snackbar_label', context);
                }
              },
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  LocalizationService.of(context)
                          ?.translate('sign_in_google_button_label') ??
                      '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () async {
                try {
                  AgentService().signInUsingGoogle();
                } catch (e) {
                  SnackBarService()
                      .errorSnackBar('general_error_snackbar_label', context);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  LocalizationService.of(context)
                          ?.translate('sign_in_google_button_label') ??
                      '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}
