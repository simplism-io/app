import 'package:base/constants/icons/organisation_icon.dart';
import 'package:base/constants/icons/password_icon.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/drop_downs/language_header_dropdown_widget.dart';
import '../../constants/headers/public_menu_header.dart';
import '../../constants/icon_buttons/github_icon_button.dart';
import '../../constants/icons/email_icon.dart';
import '../../constants/icon_buttons/public_menu_icon_button.dart';
import '../../constants/icon_buttons/theme_header_icon_button.dart';

import '../../constants/links/github_drawer_link.dart';
import '../../constants/links/faq_drawer_link.dart';
import '../../constants/links/faq_header_link.dart';
import '../../constants/links/features_drawer_link.dart';
import '../../constants/links/features_header_link.dart';
import '../../constants/links/logo_header_link.dart';
import '../../constants/links/pricing_drawer_link.dart';
import '../../constants/links/pricing_header_link.dart';
import '../../services/agent_service.dart';
import '../../services/localization_service.dart';
import '../root.dart';
import 'index_screen.dart';

final supabase = Supabase.instance.client;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? organisation;

  bool loader = false;
  bool reset = false;
  bool signup = false;

  bool obscureText = true;

  toggleObscure() {
    setState(() => obscureText = !obscureText);
  }

  toggleReset() {
    setState(() => reset = !reset);
  }

  toggleSignUp() {
    setState(() => signup = !signup);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> submitSignUp() async {
      setState(() => loader = true);
      bool result = await AgentService().signUpUsingEmailAndPassword(
          organisation: organisation, email: email, password: password);
      if (result == true) {
        setState(() {
          loader = false;
          toggleSignUp();
        });
        if (!mounted) return;
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('sign_up_snackbar_label') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() => loader = false);
        if (!mounted) return;
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

    Future<void> submitSignIn() async {
      setState(() => loader = true);
      bool result =
          await AgentService().signInUsingEmailAndPassword(email, password);
      if (result == true) {
        setState(() => {loader = false});
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Root()),
            (route) => false);
      } else {
        if (!mounted) return;
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('authentication_error_snackbar_label') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    Future<void> submitResetPassword() async {
      setState(() => loader = true);
      await AgentService().resetPassword(email);
      if (!mounted) return;
      final snackBar = SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
            LocalizationService.of(context)
                    ?.translate('reset_password_snackbar_label') ??
                '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            )),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Future<void> submitAppleSignIn() async {
      try {
        AgentService().signInUsingApple();
      } catch (e) {
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('general_error_message') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    Future<void> submitGoogleSignIn() async {
      try {
        AgentService().signInUsingGoogle();
      } catch (e) {
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              LocalizationService.of(context)
                      ?.translate('general_error_message') ??
                  '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              )),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    drawer() {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            PublicMenuHeader(),
            SizedBox(height: 20.0),
            FeaturesDrawerLink(highlight: false),
            PricingDrawerLink(highlight: false),
            FaqDrawerLink(highlight: false),
            GithubDrawerLink()
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.fromLTRB(
              ResponsiveValue(context, defaultValue: 15.0, valueWhen: const [
                    Condition.smallerThan(name: TABLET, value: 5.0)
                  ]).value ??
                  15.0,
              0.0,
              0.0,
              0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[PublicMenuIconButton(), LogoHeaderLink()],
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [
          FeaturesHeaderLink(highlight: false),
          PricingHeaderLink(highlight: false),
          FaqHeaderLink(highlight: false),
          LanguageHeaderDropdown(),
          ThemeHeaderIconButton(),
          GithubIconButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Center(
            child: SizedBox(
              width: 450,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      8.0,
                      30.0,
                      ResponsiveValue(context,
                              defaultValue: 40.0,
                              valueWhen: const [
                                Condition.smallerThan(name: TABLET, value: 8.0)
                              ]).value ??
                          40.0,
                      8.0),
                  child: Card(
                      color: Theme.of(context).colorScheme.surface,
                      elevation: 0,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 40.0),
                        child: reset == false
                            ? Form(
                                key: formKey,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                        LocalizationService.of(context)?.translate(
                                                'sign_in_up_card_header_label') ??
                                            '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 40.0),
                                    (defaultTargetPlatform ==
                                                TargetPlatform.iOS ||
                                            defaultTargetPlatform ==
                                                TargetPlatform.macOS)
                                        ? SizedBox(
                                            width: double.infinity,
                                            child: (defaultTargetPlatform ==
                                                        TargetPlatform.iOS ||
                                                    defaultTargetPlatform ==
                                                        TargetPlatform.macOS)
                                                ? CupertinoButton(
                                                    onPressed: () async {
                                                      submitAppleSignIn();
                                                    },
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        LocalizationService.of(
                                                                    context)
                                                                ?.translate(
                                                                    'sign_in_apple_button_label') ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSecondary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                : ElevatedButton(
                                                    onPressed: () async {
                                                      submitAppleSignIn();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Text(
                                                        LocalizationService.of(
                                                                    context)
                                                                ?.translate(
                                                                    'sign_in_apple_button_label') ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSecondary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                          )
                                        : Container(),
                                    (defaultTargetPlatform ==
                                                TargetPlatform.iOS ||
                                            defaultTargetPlatform ==
                                                TargetPlatform.macOS)
                                        ? const SizedBox(height: 15.0)
                                        : Container(),
                                    SizedBox(
                                      width: double.infinity,
                                      child: (defaultTargetPlatform ==
                                                  TargetPlatform.iOS ||
                                              defaultTargetPlatform ==
                                                  TargetPlatform.macOS)
                                          ? CupertinoButton(
                                              onPressed: () async {
                                                submitGoogleSignIn();
                                              },
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  LocalizationService.of(
                                                              context)
                                                          ?.translate(
                                                              'sign_in_google_button_label') ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () async {
                                                submitGoogleSignIn();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  LocalizationService.of(
                                                              context)
                                                          ?.translate(
                                                              'sign_in_google_button_label') ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(height: 30.0),
                                    Row(children: <Widget>[
                                      const Expanded(child: Divider()),
                                      Text(
                                          LocalizationService.of(context)
                                                  ?.translate('or') ??
                                              '',
                                          style: TextStyle(
                                            fontSize: ResponsiveValue(context,
                                                defaultValue: 15.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                      name: DESKTOP,
                                                      value: 15.0),
                                                ]).value,
                                          )),
                                      const Expanded(child: Divider()),
                                    ]),
                                    const SizedBox(height: 30.0),
                                    signup == true
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: TextFormField(
                                                    decoration: InputDecoration(
                                                      border: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      labelText: LocalizationService
                                                                  .of(context)
                                                              ?.translate(
                                                                  'organisation_input_label') ??
                                                          '',
                                                      labelStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                      ), //label style
                                                      prefixIcon:
                                                          const OrganisationIcon(
                                                              size: 20),
                                                      hintText: LocalizationService
                                                                  .of(context)
                                                              ?.translate(
                                                                  'organisation_input_label') ??
                                                          '',
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
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
                                                          ? LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'invalid_organisation_message') ??
                                                              ''
                                                          : null;
                                                    },
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          organisation = val);
                                                    }),
                                              ),
                                              const SizedBox(height: 15.0),
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: LocalizationService
                                                          .of(context)
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
                                              labelText: LocalizationService.of(
                                                          context)
                                                      ?.translate(
                                                          'email_input_label') ??
                                                  '',
                                              labelStyle: const TextStyle(
                                                fontSize: 15,
                                              ), //label style
                                              prefixIcon: const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 0, 15, 0),
                                                child: EmailIcon(size: 20),
                                              )),
                                          textAlign: TextAlign.left,
                                          initialValue: email,
                                          autofocus: true,
                                          validator: (String? value) {
                                            return !EmailValidator.validate(
                                                    value!)
                                                ? 'Please provide a valid email.'
                                                : null;
                                          },
                                          onChanged: (val) {
                                            setState(() => email = val);
                                          }),
                                    ),
                                    const SizedBox(height: 15.0),
                                    SizedBox(
                                        width: double.infinity,
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              labelText: LocalizationService.of(
                                                          context)
                                                      ?.translate(
                                                          'password_input_label') ??
                                                  '',
                                              labelStyle: const TextStyle(
                                                fontSize: 15,
                                              ), //label style
                                              prefixIcon: const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 0, 15, 0),
                                                child: PasswordIcon(size: 20),
                                              ),
                                              suffixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
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
                                                              ? CupertinoIcons
                                                                  .eye
                                                              : FontAwesomeIcons
                                                                  .eye
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
                                                  ? LocalizationService.of(
                                                              context)
                                                          ?.translate(
                                                              'invalid_password_message') ??
                                                      ''
                                                  : null;
                                            },
                                            onChanged: (val) {
                                              setState(() => password = val);
                                            })),
                                    const SizedBox(height: 15.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: signup == false
                                          ? (defaultTargetPlatform ==
                                                      TargetPlatform.iOS ||
                                                  defaultTargetPlatform ==
                                                      TargetPlatform.macOS)
                                              ? CupertinoButton(
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      submitSignIn();
                                                    } else {
                                                      setState(() => {
                                                            loader = false,
                                                          });
                                                    }
                                                  },
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      loader == true
                                                          ? LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'loader_button_label') ??
                                                              ''
                                                          : LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'sign_in_button_label') ??
                                                              '',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      submitSignIn();
                                                    } else {
                                                      setState(() => {
                                                            loader = false,
                                                          });
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Text(
                                                      loader == true
                                                          ? LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'loader_button_label') ??
                                                              ''
                                                          : LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'sign_in_button_label') ??
                                                              '',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                          : (defaultTargetPlatform ==
                                                      TargetPlatform.iOS ||
                                                  defaultTargetPlatform ==
                                                      TargetPlatform.macOS)
                                              ? CupertinoButton(
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      submitSignUp();
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      loader == true
                                                          ? LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'loader_button_label') ??
                                                              ''
                                                          : LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'sign_up_button_label') ??
                                                              '',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      submitSignUp();
                                                    } else {
                                                      setState(() {
                                                        loader = false;
                                                      });
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                      shape:
                                                          MaterialStateProperty
                                                              .all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Text(
                                                      loader == true
                                                          ? LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'loader_button_label') ??
                                                              ''
                                                          : LocalizationService
                                                                      .of(
                                                                          context)
                                                                  ?.translate(
                                                                      'sign_up_button_label') ??
                                                              '',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    GestureDetector(
                                        child: Text(
                                            LocalizationService.of(context)
                                                    ?.translate(
                                                        'reset_password_link_label') ??
                                                '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        onTap: () {
                                          toggleReset();
                                        }),
                                    const SizedBox(height: 30.0),
                                    Row(children: <Widget>[
                                      const Expanded(child: Divider()),
                                      Text(
                                          LocalizationService.of(context)
                                                  ?.translate('or') ??
                                              '',
                                          style: TextStyle(
                                            fontSize: ResponsiveValue(context,
                                                defaultValue: 15.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                      name: DESKTOP,
                                                      value: 15.0),
                                                ]).value,
                                          )),
                                      const Expanded(child: Divider()),
                                    ]),
                                    const SizedBox(height: 30.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: (defaultTargetPlatform ==
                                                  TargetPlatform.iOS ||
                                              defaultTargetPlatform ==
                                                  TargetPlatform.macOS)
                                          ? CupertinoButton(
                                              onPressed: () {
                                                toggleSignUp();
                                              },
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  signup == false
                                                      ? LocalizationService.of(
                                                                  context)
                                                              ?.translate(
                                                                  'sign_up_switcher_link_label') ??
                                                          ''
                                                      : LocalizationService.of(
                                                                  context)
                                                              ?.translate(
                                                                  'sign_in_switcher_link_label') ??
                                                          '',
                                                  style: TextStyle(
                                                      fontSize: ResponsiveValue(
                                                          context,
                                                          defaultValue: 15.0,
                                                          valueWhen: const [
                                                            Condition
                                                                .smallerThan(
                                                                    name:
                                                                        DESKTOP,
                                                                    value:
                                                                        15.0),
                                                          ]).value,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                              onPressed: () {
                                                toggleSignUp();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  signup == false
                                                      ? LocalizationService.of(
                                                                  context)
                                                              ?.translate(
                                                                  'sign_up_switcher_link_label') ??
                                                          ''
                                                      : LocalizationService.of(
                                                                  context)
                                                              ?.translate(
                                                                  'sign_in_switcher_link_label') ??
                                                          '',
                                                  style: TextStyle(
                                                      fontSize: ResponsiveValue(
                                                          context,
                                                          defaultValue: 15.0,
                                                          valueWhen: const [
                                                            Condition
                                                                .smallerThan(
                                                                    name:
                                                                        DESKTOP,
                                                                    value:
                                                                        15.0),
                                                          ]).value,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                    ),
                                    (defaultTargetPlatform ==
                                                TargetPlatform.iOS ||
                                            defaultTargetPlatform ==
                                                TargetPlatform.android)
                                        ? Container()
                                        : Column(
                                            children: [
                                              const SizedBox(height: 30),
                                              Center(
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minimumSize:
                                                            const Size(50, 30),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        alignment: Alignment
                                                            .centerLeft),
                                                    onPressed: () => {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const IndexScreen()),
                                                                  (route) =>
                                                                      false)
                                                        },
                                                    child: Text(LocalizationService
                                                                .of(context)
                                                            ?.translate(
                                                                'go_back_link_label') ??
                                                        '')),
                                              ),
                                            ],
                                          ),
                                  ],
                                ))
                            : Form(
                                key: formKey,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                        LocalizationService.of(context)?.translate(
                                                'reset_password_header_label') ??
                                            '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 40.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: LocalizationService
                                                          .of(context)
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
                                              labelText: LocalizationService.of(
                                                          context)
                                                      ?.translate(
                                                          'email_input_label') ??
                                                  '',
                                              labelStyle: const TextStyle(
                                                fontSize: 15,
                                              ), //label style
                                              prefixIcon:
                                                  const EmailIcon(size: 15)),
                                          textAlign: TextAlign.left,
                                          initialValue: email,
                                          autofocus: true,
                                          validator: (String? value) {
                                            return !EmailValidator.validate(
                                                    value!)
                                                ? 'Please provide a valid email.'
                                                : null;
                                          },
                                          onChanged: (val) {
                                            setState(() => email = val);
                                          }),
                                    ),
                                    const SizedBox(height: 15.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: (defaultTargetPlatform ==
                                                  TargetPlatform.iOS ||
                                              defaultTargetPlatform ==
                                                  TargetPlatform.macOS)
                                          ? CupertinoButton(
                                              onPressed: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  submitResetPassword();
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                                  'reset_password_button_label') ??
                                                          '',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : ElevatedButton(
                                              onPressed: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  submitResetPassword();
                                                } else {
                                                  setState(() {
                                                    loader = false;
                                                  });
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
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
                                                                  'reset_password_button_label') ??
                                                          '',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(height: 30.0),
                                    GestureDetector(
                                        child: Text(
                                            LocalizationService.of(context)
                                                    ?.translate(
                                                        'go_back_home_link_label') ??
                                                '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        onTap: () {
                                          toggleReset();
                                        }),
                                  ],
                                )),
                      ))),
            ),
          ),
        ),
      ),
      drawer: drawer(),
    );
  }
}
