import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/agent_service.dart';
import '../../services/snackbar_service.dart';

class SignInUpButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const SignInUpButtonWidget({super.key, required this.formKey});

  @override
  State<SignInUpButtonWidget> createState() => _SignInUpButtonWidgetState();
}

class _SignInUpButtonWidgetState extends State<SignInUpButtonWidget> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 300.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: Consumer<FormService>(
          builder: (context, form, child) => form.signup == false
              ? (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.macOS)
                  ? CupertinoButton(
                      onPressed: () async {
                        if (widget.formKey.currentState!.validate()) {
                          setState(() => loader = true);
                          bool success = await AgentService()
                              .signInUsingEmailAndPassword(
                                  FormService.email, FormService.password);
                          if (success == false) {
                            if (!mounted) return;
                            setState(() => {loader = false});
                            SnackBarService().errorSnackBar(
                                'authentication_error_snackbar_label', context);
                          }
                        } else {
                          setState(() => {
                                loader = false,
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
                                      ?.translate('sign_in_button_label') ??
                                  '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (widget.formKey.currentState!.validate()) {
                          setState(() => loader = true);
                          bool success = await AgentService()
                              .signInUsingEmailAndPassword(
                                  FormService.email, FormService.password);
                          if (success == false) {
                            if (!mounted) return;
                            setState(() => {loader = false});
                            SnackBarService().errorSnackBar(
                                'authentication_error_snackbar_label', context);
                          }
                        } else {
                          setState(() => {
                                loader = false,
                              });
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          loader == true
                              ? LocalizationService.of(context)
                                      ?.translate('loader_button_label') ??
                                  ''
                              : LocalizationService.of(context)
                                      ?.translate('sign_in_button_label') ??
                                  '',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
              : (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.macOS)
                  ? CupertinoButton(
                      onPressed: () async {
                        if (widget.formKey.currentState!.validate()) {
                          setState(() => loader = true);
                          bool success = await AgentService()
                              .signUpUsingEmailAndPassword(
                                  email: FormService.email,
                                  password: FormService.password);
                          if (success == true) {
                            if (!mounted) return;
                            setState(() => loader = false);
                            SnackBarService().successSnackBar(
                                'sign_up_snackbar_label', context);
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
                                      ?.translate('sign_up_button_label') ??
                                  '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (widget.formKey.currentState!.validate()) {
                          setState(() => loader = true);
                          bool success = await AgentService()
                              .signUpUsingEmailAndPassword(
                                  organisation: FormService.organisation,
                                  email: FormService.email,
                                  password: FormService.password);
                          if (success == true) {
                            if (!mounted) return;
                            setState(() => loader = false);
                            SnackBarService().successSnackBar(
                                'sign_up_snackbar_label', context);
                          }
                        } else {
                          setState(() {
                            loader = false;
                          });
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          loader == true
                              ? LocalizationService.of(context)
                                      ?.translate('loader_button_label') ??
                                  ''
                              : LocalizationService.of(context)
                                      ?.translate('sign_up_button_label') ??
                                  '',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
        ));
  }
}
