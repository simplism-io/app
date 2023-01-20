import 'package:base/constants/icons/email_icon.dart';
import 'package:base/constants/icons/imap_icon.dart';
import 'package:base/screens/private/email/mailbox_overview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../constants/icons/password_icon.dart';
import '../../../constants/icons/port_icon.dart';
import '../../../constants/icons/smtp_icon.dart';
import '../../../services/localization_service.dart';
import '../../../services/mailbox_service.dart';

class UpdateMailboxScreen extends StatefulWidget {
  const UpdateMailboxScreen({super.key});

  @override
  State<UpdateMailboxScreen> createState() => _UpdateMailboxScreenState();
}

class _UpdateMailboxScreenState extends State<UpdateMailboxScreen> {
  final formKey = GlobalKey<FormState>();
  bool loader = false;

  String? email;
  String? password;
  String? imapUrl;
  String? imapPort;
  String? smtpUrl;
  String? smtpPort;

  bool obscureText = true;

  toggleObscure() {
    setState(() => obscureText = !obscureText);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      setState(() => loader = true);
      final result = await MailBoxService()
          .createMailbox(email, password, imapUrl, imapPort, smtpUrl, smtpPort);
      if (result == true) {
        if (!mounted) return;
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('create_mailbox_name_snackbar_label') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MailboxOverviewScreen()),
            (route) => false);
      } else {
        setState(() {
          loader = false;
        });
        if (!mounted) return;
        setState(() => {loader = false});
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('general_error_snackbar_label') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(
          leading: ResponsiveVisibility(
            visible: false,
            visibleWhen: const [Condition.smallerThan(name: TABLET)],
            child: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 20.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            }),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background),
      body: Column(children: [
        Center(
          child: SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 450.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 450.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            onPressed: () => {
                                  Navigator.pop(context),
                                },
                            child: Text(LocalizationService.of(context)
                                    ?.translate('go_back_link_label') ??
                                '')),
                        const SizedBox(height: 20),
                        Text(
                            LocalizationService.of(context)?.translate(
                                    'create_mailbox_header_label') ??
                                '',
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                        const SizedBox(height: 40.0),
                        Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: ResponsiveValue(context,
                                      defaultValue: 360.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                            name: MOBILE, value: 360.0),
                                        Condition.smallerThan(
                                            name: TABLET,
                                            value: double.infinity)
                                      ]).value,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText:
                                            LocalizationService.of(context)
                                                    ?.translate(
                                                        'email_input_label') ??
                                                '',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                        ), //label style
                                        prefixIcon: const EmailIcon(),
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'email_input_hinttext') ??
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
                                      ),
                                      textAlign: TextAlign.left,
                                      autofocus: true,
                                      validator: (String? value) {
                                        //print(value.length);
                                        return (value != null &&
                                                value.length < 2)
                                            ? LocalizationService.of(context)
                                                    ?.translate(
                                                        'invalid_email_message') ??
                                                ''
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      }),
                                ),
                                const SizedBox(height: 15.0),
                                SizedBox(
                                    width: ResponsiveValue(context,
                                        defaultValue: 360.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                              name: MOBILE, value: 360.0),
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
                                                      'password_input_hinttext') ??
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
                                                      'password_input_label') ??
                                              '',
                                          labelStyle: const TextStyle(
                                            fontSize: 15,
                                          ), //label style
                                          prefixIcon: const PasswordIcon(),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 15, 0),
                                            child: IconButton(
                                                onPressed: () =>
                                                    toggleObscure(),
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
                                          setState(() => password = val);
                                        })),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: ResponsiveValue(context,
                                      defaultValue: 360.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                            name: MOBILE, value: 360.0),
                                        Condition.smallerThan(
                                            name: TABLET,
                                            value: double.infinity)
                                      ]).value,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'imap_url_input_label') ??
                                            '',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                        ), //label style
                                        prefixIcon: const ImapIcon(),
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'imap_url_input_hinttext') ??
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
                                      ),
                                      textAlign: TextAlign.left,
                                      autofocus: true,
                                      validator: (String? value) {
                                        //print(value.length);
                                        return (value != null &&
                                                value.length < 2)
                                            ? LocalizationService.of(context)
                                                    ?.translate(
                                                        'invalid_imap_url_message') ??
                                                ''
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => imapUrl = val);
                                      }),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: ResponsiveValue(context,
                                      defaultValue: 360.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                            name: MOBILE, value: 360.0),
                                        Condition.smallerThan(
                                            name: TABLET,
                                            value: double.infinity)
                                      ]).value,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'imap_port_input_label') ??
                                            '',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                        ), //label style
                                        prefixIcon: const PortIcon(),
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'imap_port_input_hinttext') ??
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
                                      ),
                                      textAlign: TextAlign.left,
                                      autofocus: true,
                                      validator: (String? value) {
                                        //print(value.length);
                                        return (value != null &&
                                                value.length < 2)
                                            ? LocalizationService.of(context)
                                                    ?.translate(
                                                        'invalid_imap_port_message') ??
                                                ''
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => imapPort = val);
                                      }),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: ResponsiveValue(context,
                                      defaultValue: 360.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                            name: MOBILE, value: 360.0),
                                        Condition.smallerThan(
                                            name: TABLET,
                                            value: double.infinity)
                                      ]).value,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'smtp_url_input_label') ??
                                            '',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                        ), //label style
                                        prefixIcon: const SmtpIcon(),
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'smtp_url_input_hinttext') ??
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
                                      ),
                                      textAlign: TextAlign.left,
                                      autofocus: true,
                                      validator: (String? value) {
                                        //print(value.length);
                                        return (value != null &&
                                                value.length < 2)
                                            ? LocalizationService.of(context)
                                                    ?.translate(
                                                        'invalid_smtp_url_message') ??
                                                ''
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => smtpUrl = val);
                                      }),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: ResponsiveValue(context,
                                      defaultValue: 360.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                            name: MOBILE, value: 360.0),
                                        Condition.smallerThan(
                                            name: TABLET,
                                            value: double.infinity)
                                      ]).value,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        labelText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'smtp_port_input_label') ??
                                            '',
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                        ), //label style
                                        prefixIcon: const PortIcon(),
                                        hintText: LocalizationService.of(
                                                    context)
                                                ?.translate(
                                                    'smtp_port_input_hinttext') ??
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
                                      ),
                                      textAlign: TextAlign.left,
                                      autofocus: true,
                                      validator: (String? value) {
                                        //print(value.length);
                                        return (value != null &&
                                                value.length < 2)
                                            ? LocalizationService.of(context)
                                                    ?.translate(
                                                        'invalid_smtp_port_message') ??
                                                ''
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => smtpPort = val);
                                      }),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: ResponsiveValue(context,
                                      defaultValue: 360.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                            name: MOBILE, value: 360.0),
                                        Condition.smallerThan(
                                            name: TABLET,
                                            value: double.infinity)
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
                                                            'create_mailbox_button_label') ??
                                                    '',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : ElevatedButton(
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
                                                              'create_mailbox_button_label') ??
                                                      '',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ))),
        )
      ]),
    );
  }
}
