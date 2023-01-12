import 'package:base/widgets/screens/bouncer_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/agent_service.dart';
import '../../services/snackbar_service.dart';
import '../screens/private/profile_screen_widget.dart';

class UpdateProfileButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const UpdateProfileButtonWidget({super.key, required this.formKey});

  @override
  State<UpdateProfileButtonWidget> createState() =>
      _UpdateProfileButtonWidgetState();
}

class _UpdateProfileButtonWidgetState extends State<UpdateProfileButtonWidget> {
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
                  final response = await AgentService().updateProfileProcedure(
                      FormService.name, FormService.email, FormService.avatar);
                  if (response == true) {
                    final updatedAgent = await AgentService().loadAgent();
                    if (!mounted) return;
                    SnackBarService().successSnackBar(
                        'update_profile_snackbar_label', context);
                    if (EmailValidator.validate(updatedAgent!.email)) {
                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreenWidget(agent: updatedAgent)),
                              (route) => false);
                    } else {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const BouncerWidget()),
                              (route) => false);
                    }
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
                    setState(() => {loader = false});
                    SnackBarService().errorSnackBar(
                        'authentication_error_snackbar_label', context);
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
                              ?.translate('update_profile_button_label') ??
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
                  final response = await AgentService().updateProfileProcedure(
                      FormService.name, FormService.email, FormService.avatar);
                  if (response == true) {
                    final newProfile = await AgentService().loadAgent();
                    if (!mounted) return;
                    SnackBarService().successSnackBar(
                        'update_profile_snackbar_label', context);
                    if (EmailValidator.validate(newProfile!.email)) {
                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreenWidget(agent: newProfile)),
                              (route) => false);
                    } else {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const BouncerWidget()),
                              (route) => false);
                    }
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
                    setState(() => {loader = false});
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
                              ?.translate('update_profile_button_label') ??
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
