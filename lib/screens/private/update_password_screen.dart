// ignore_for_file: file_names

import 'package:base/constants/icons/password_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/agent_service.dart';
import '../../services/localization_service.dart';
import '../../constants/icons/go_back_icon.dart';
import '../../constants/links/go_back_link.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final dynamic agent;
  const UpdatePasswordScreen({Key? key, this.agent}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  bool loader = false;

  late bool obscureText;

  String? newPassword;
  String? newPasswordAgain;

  toggleObscure() {
    obscureText = !obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      setState(() => loader = true);
      final response = await AgentService().updatePassword(newPassword);
      setState(() => loader = false);
      if (response == true) {
        if (!mounted) return;
        // SnackBarService()
        //     .successSnackBar('update_password_snackbar_label', context);
        // Navigator.pop(context);
      } else {
        setState(() {
          loader = false;
        });
        if (!mounted) return;
        // SnackBarService()
        //     .errorSnackBar('general_error_snackbar_label', context);
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: const GoBackIconWidget(),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 450.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 450.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.onSurface,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Text(
                                  LocalizationService.of(context)?.translate(
                                          'update_password_header_label') ??
                                      '',
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 40.0),
                              SizedBox(
                                  width: ResponsiveValue(context,
                                      defaultValue: 400.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                            name: MOBILE, value: 400.0),
                                        Condition.smallerThan(
                                            name: TABLET,
                                            value: double.infinity)
                                      ]).value,
                                  child: TextFormField(
                                      obscureText: obscureText,
                                      decoration: InputDecoration(
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'new_password_input_hinttext') ??
                                            '',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'new_password_input_label') ??
                                            '',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                        ), //label style
                                        prefixIcon: const PasswordIcon(),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 15, 0),
                                          child: IconButton(
                                              onPressed: () => toggleObscure(),
                                              icon: Icon(
                                                obscureText == true
                                                    ? (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoIcons.eye
                                                        : FontAwesomeIcons.eye
                                                    : (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoIcons
                                                            .eye_slash
                                                        : FontAwesomeIcons
                                                            .eyeSlash,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                size: 20.0,
                                              )),
                                        ),
                                      ),
                                      textAlign: TextAlign.left,
                                      autofocus: true,
                                      validator: (String? value) {
                                        return (value != null &&
                                                value.length < 2)
                                            ? LocalizationService.of(context)
                                                    ?.translate(
                                                        'invalid_password_message') ??
                                                ''
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => newPassword = val);
                                      })),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                width: ResponsiveValue(context,
                                    defaultValue: 400.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                          name: MOBILE, value: 400.0),
                                      Condition.smallerThan(
                                          name: TABLET, value: double.infinity)
                                    ]).value,
                                child: TextFormField(
                                    obscureText: obscureText,
                                    decoration: InputDecoration(
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'new_password_again_input_hinttext') ??
                                            '',
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 1.0,
                                          ),
                                        ),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'new_password_again_input_label') ??
                                            '',
                                        labelStyle: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ), //label style
                                        prefixIcon: const PasswordIcon(),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 15, 0),
                                          child: IconButton(
                                              onPressed: () => toggleObscure(),
                                              icon: Icon(
                                                obscureText == true
                                                    ? (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoIcons.eye
                                                        : FontAwesomeIcons.eye
                                                    : (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoIcons
                                                            .eye_slash
                                                        : FontAwesomeIcons
                                                            .eyeSlash,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                size: 20.0,
                                              )),
                                        )),
                                    textAlign: TextAlign.left,
                                    autofocus: false,
                                    validator: (String? value) {
                                      return (value != newPassword)
                                          ? LocalizationService.of(context)
                                                  ?.translate(
                                                      'invalid_password_again_message') ??
                                              ''
                                          : null;
                                    },
                                    onChanged: (val) {
                                      setState(() => newPasswordAgain = val);
                                    }),
                              ),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                width: ResponsiveValue(context,
                                    defaultValue: 400.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                          name: MOBILE, value: 400.0),
                                      Condition.smallerThan(
                                          name: TABLET, value: double.infinity)
                                    ]).value,
                                child: (defaultTargetPlatform ==
                                            TargetPlatform.iOS ||
                                        defaultTargetPlatform ==
                                            TargetPlatform.macOS)
                                    ? CupertinoButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            submit();
                                          } else {
                                            setState(() {
                                              loader = false;
                                            });
                                          }
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            loader == true
                                                ? LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'loader_button_label') ??
                                                    ''
                                                : LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'update_password_button_label') ??
                                                    '',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            setState(() => loader = true);
                                            submit();
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
                                                ? LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'loader_button_label') ??
                                                    ''
                                                : LocalizationService.of(
                                                            context)
                                                        ?.translate(
                                                            'update_password_button_label') ??
                                                    '',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GoBackLink(
                      removeState: false,
                      label: LocalizationService.of(context)
                              ?.translate('go_back_profile_link_label') ??
                          ''),
                ],
              ),
            ),
          ),
        ));
  }
}
