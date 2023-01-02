import 'package:base/widgets/screens/bouncer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/agent_service.dart';
import '../../services/snackbar_service.dart';

class CreateOrganisationButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const CreateOrganisationButtonWidget({super.key, required this.formKey});

  @override
  State<CreateOrganisationButtonWidget> createState() =>
      _CreateOrganisationButtonWidgetState();
}

class _CreateOrganisationButtonWidgetState
    extends State<CreateOrganisationButtonWidget> {
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
                  final result = await AgentService()
                      .createAgentProcedure(FormService.organisation);
                  if (result == true) {
                    if (!mounted) return;
                    SnackBarService().successSnackBar(
                        'create_organisation_snackbar_label', context);
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const BouncerWidget()),
                            (route) => false);
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
                    setState(() => {loader = false});
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
              child: Text(
                loader == true
                    ? LocalizationService.of(context)
                            ?.translate('loader_button_label') ??
                        ''
                    : LocalizationService.of(context)
                            ?.translate('create_organisation_button_label') ??
                        '',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            )
          : ElevatedButton(
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  setState(() => loader = true);
                  final result = await AgentService()
                      .createAgentProcedure(FormService.organisation);
                  if (result == true) {
                    if (!mounted) return;
                    SnackBarService().successSnackBar(
                        'create_organisation_snackbar_label', context);
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const BouncerWidget()),
                            (route) => false);
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
                    setState(() => {loader = false});
                    SnackBarService()
                        .errorSnackBar('general_error_snackbar_label', context);
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
                              ?.translate('create_organisation_button_label') ??
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
