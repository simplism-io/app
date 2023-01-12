import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/agent_service.dart';
import '../../services/snackbar_service.dart';

class UpdatePasswordButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const UpdatePasswordButtonWidget({super.key, required this.formKey});

  @override
  State<UpdatePasswordButtonWidget> createState() =>
      _UpdatePasswordButtonWidgetState();
}

class _UpdatePasswordButtonWidgetState
    extends State<UpdatePasswordButtonWidget> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 400.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 400.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? CupertinoButton(
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  setState(() => loader = true);
                  final response = await AgentService()
                      .updatePassword(FormService.newPassword);
                  setState(() => loader = false);
                  if (response == true) {
                    if (!mounted) return;
                    SnackBarService().successSnackBar(
                        'update_password_snackbar_label', context);
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
                    SnackBarService()
                        .errorSnackBar('general_error_snackbar_label', context);
                  }
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
                              ?.translate('update_password_button_label') ??
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
                  final response = await AgentService()
                      .updatePassword(FormService.newPassword);
                  setState(() => loader = false);
                  if (response == true) {
                    if (!mounted) return;
                    SnackBarService().successSnackBar(
                        'update_password_snackbar_label', context);
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
                    SnackBarService().errorSnackBar(
                        'authentication_error_snackbar_label', context);
                  }
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
                              ?.translate('update_password_button_label') ??
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
