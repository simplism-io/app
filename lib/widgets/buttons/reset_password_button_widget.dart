import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/agent_service.dart';
import '../../services/snackbar_service.dart';

class ResetPasswordButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const ResetPasswordButtonWidget({super.key, required this.formKey});

  @override
  State<ResetPasswordButtonWidget> createState() =>
      _ResetPasswordButtonWidgetState();
}

class _ResetPasswordButtonWidgetState extends State<ResetPasswordButtonWidget> {
  bool loader = false;

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
                if (widget.formKey.currentState!.validate()) {
                  setState(() => loader = true);
                  await AgentService().resetPassword(FormService.email);
                  if (!mounted) return;
                  SnackBarService().successSnackBar(
                      'reset_password_snackbar_label', context);
                } else {
                  setState(() {
                    loader = false;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  loader == true
                      ? LocalizationService.of(context)
                              ?.translate('loader_button_label') ??
                          ''
                      : LocalizationService.of(context)
                              ?.translate('reset_password_button_label') ??
                          '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  setState(() => loader = true);
                  await AgentService().resetPassword(FormService.email);
                  if (!mounted) return;
                  SnackBarService().successSnackBar(
                      'reset_password_snackbar_label', context);
                } else {
                  setState(() {
                    loader = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  loader == true
                      ? LocalizationService.of(context)
                              ?.translate('loader_button_label') ??
                          ''
                      : LocalizationService.of(context)
                              ?.translate('reset_password_button_label') ??
                          '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}
