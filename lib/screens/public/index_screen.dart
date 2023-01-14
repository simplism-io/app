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
import '../../constants/icons/email_icon.dart';
import '../../constants/icons/public_menu_icon.dart';
import '../../constants/icons/theme_header_icon.dart';
import '../../constants/links/about_drawer_link.dart';
import '../../constants/links/about_header_link.dart';
import '../../constants/links/faq_drawer_link.dart';
import '../../constants/links/faq_header_link.dart';
import '../../constants/links/features_drawer_link.dart';
import '../../constants/links/features_header_link.dart';
import '../../constants/links/logo_header_link.dart';
import '../../constants/links/pricing_drawer_link.dart';
import '../../constants/links/pricing_header_link.dart';
import '../../services/agent_service.dart';
import '../../services/localization_service.dart';

final supabase = Supabase.instance.client;

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? organisation;

  bool loader = false;
  bool reset = false;
  bool signup = false;

  bool obscureText = false;

  toggleObscure() {
    obscureText = !obscureText;
  }

  toggleReset() {
    reset = !reset;
  }

  toggleSignUp() {
    signup = !signup;
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
          AboutDrawerLink(highlight: false)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            children: const <Widget>[PublicMenuIcon(), LogoHeaderLink()],
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [
          FeaturesHeaderLink(highlight: false),
          PricingHeaderLink(highlight: false),
          AboutUsHeaderLink(highlight: false),
          FaqHeaderLink(highlight: false),
          LanguageHeaderDropdown(),
          ThemeHeaderIcon(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveRowColumn(
                layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                rowMainAxisAlignment: MainAxisAlignment.center,
                columnCrossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: ResponsiveVisibility(
                        hiddenWhen: const [Condition.smallerThan(name: TABLET)],
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ResponsiveValue(context,
                                          defaultValue: 0.0,
                                          valueWhen: const [
                                            Condition.smallerThan(
                                                name: DESKTOP, value: 40.0)
                                          ]).value ??
                                      0.0,
                                  10.0,
                                  50.0,
                                  10.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: ResponsiveValue(context,
                                        defaultValue: 500.0,
                                        valueWhen: const [
                                          Condition.smallerThan(
                                              name: DESKTOP, value: 400.0)
                                        ]).value,
                                    child: Text(
                                        LocalizationService.of(context)
                                                ?.translate('main_tagline') ??
                                            '',
                                        style: TextStyle(
                                            fontFamily: 'OpenSansExtraBold',
                                            fontSize: ResponsiveValue(context,
                                                defaultValue: 50.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                      name: DESKTOP,
                                                      value: 40.0),
                                                ]).value,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    width: ResponsiveValue(context,
                                        defaultValue: 500.0,
                                        valueWhen: const [
                                          Condition.smallerThan(
                                              name: DESKTOP, value: 400.0)
                                        ]).value,
                                    child: Text(
                                        LocalizationService.of(context)
                                                ?.translate('sub_tagline') ??
                                            '',
                                        style: TextStyle(
                                            fontSize: ResponsiveValue(context,
                                                defaultValue: 25.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                      name: DESKTOP,
                                                      value: 20.0),
                                                ]).value,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Column(
                        children: [
                          SizedBox(
                            width: ResponsiveValue(context,
                                defaultValue: 450.0,
                                valueWhen: const [
                                  Condition.largerThan(
                                      name: MOBILE, value: 450.0),
                                  Condition.smallerThan(
                                      name: TABLET, value: double.infinity)
                                ]).value,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    8.0,
                                    30.0,
                                    ResponsiveValue(context,
                                            defaultValue: 40.0,
                                            valueWhen: const [
                                              Condition.smallerThan(
                                                  name: TABLET, value: 8.0)
                                            ]).value ??
                                        40.0,
                                    8.0),
                                child: Card(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 30.0, 15.0, 40.0),
                                      child: reset == false
                                          ? Form(
                                              key: formKey,
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                      LocalizationService.of(
                                                                  context)
                                                              ?.translate(
                                                                  'sign_in_up_card_header_label') ??
                                                          '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(height: 40.0),
                                                  (defaultTargetPlatform ==
                                                              TargetPlatform
                                                                  .iOS ||
                                                          defaultTargetPlatform ==
                                                              TargetPlatform
                                                                  .macOS)
                                                      ? SizedBox(
                                                          width: ResponsiveValue(
                                                              context,
                                                              defaultValue:
                                                                  300.0,
                                                              valueWhen: const [
                                                                Condition.largerThan(
                                                                    name:
                                                                        MOBILE,
                                                                    value:
                                                                        300.0),
                                                                Condition.smallerThan(
                                                                    name:
                                                                        TABLET,
                                                                    value: double
                                                                        .infinity)
                                                              ]).value,
                                                          child: (defaultTargetPlatform ==
                                                                      TargetPlatform
                                                                          .iOS ||
                                                                  defaultTargetPlatform ==
                                                                      TargetPlatform
                                                                          .macOS)
                                                              ? CupertinoButton(
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      AgentService()
                                                                          .signInUsingApple();
                                                                    } catch (e) {
                                                                      // SnackBarService().errorSnackBar('general_error_snackbar_label',
                                                                      //     context);
                                                                    }
                                                                  },
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child: Text(
                                                                      LocalizationService.of(context)
                                                                              ?.translate('sign_in_apple_button_label') ??
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
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      AgentService()
                                                                          .signInUsingGoogle();
                                                                    } catch (e) {
                                                                      // SnackBarService().errorSnackBar('general_error_snackbar_label',
                                                                      //     context);
                                                                    }
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                    child: Text(
                                                                      LocalizationService.of(context)
                                                                              ?.translate('sign_in_apple_button_label') ??
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
                                                        )
                                                      : Container(),
                                                  (defaultTargetPlatform ==
                                                              TargetPlatform
                                                                  .iOS ||
                                                          defaultTargetPlatform ==
                                                              TargetPlatform
                                                                  .macOS)
                                                      ? const SizedBox(
                                                          height: 15.0)
                                                      : Container(),
                                                  SizedBox(
                                                    width: ResponsiveValue(
                                                        context,
                                                        defaultValue: 300.0,
                                                        valueWhen: const [
                                                          Condition.largerThan(
                                                              name: MOBILE,
                                                              value: 300.0),
                                                          Condition.smallerThan(
                                                              name: TABLET,
                                                              value: double
                                                                  .infinity)
                                                        ]).value,
                                                    child: (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                AgentService()
                                                                    .signInUsingGoogle();
                                                              } catch (e) {
                                                                // SnackBarService().errorSnackBar(
                                                                //     'general_error_snackbar_label',
                                                                //     context);
                                                              }
                                                            },
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                LocalizationService.of(
                                                                            context)
                                                                        ?.translate(
                                                                            'sign_in_google_button_label') ??
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
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                AgentService()
                                                                    .signInUsingGoogle();
                                                              } catch (e) {
                                                                // SnackBarService().errorSnackBar(
                                                                //     'general_error_snackbar_label',
                                                                //     context);
                                                              }
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                LocalizationService.of(
                                                                            context)
                                                                        ?.translate(
                                                                            'sign_in_google_button_label') ??
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
                                                  ),
                                                  const SizedBox(height: 30.0),
                                                  Row(children: <Widget>[
                                                    const Expanded(
                                                        child: Divider()),
                                                    Text(
                                                        LocalizationService.of(
                                                                    context)
                                                                ?.translate(
                                                                    'or') ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: ResponsiveValue(
                                                              context,
                                                              defaultValue:
                                                                  15.0,
                                                              valueWhen: const [
                                                                Condition.smallerThan(
                                                                    name:
                                                                        DESKTOP,
                                                                    value:
                                                                        15.0),
                                                              ]).value,
                                                        )),
                                                    const Expanded(
                                                        child: Divider()),
                                                  ]),
                                                  const SizedBox(height: 30.0),
                                                  signup == true
                                                      ? Column(
                                                          children: [
                                                            TextFormField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  border: const OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5))),
                                                                  labelText: LocalizationService.of(
                                                                              context)
                                                                          ?.translate(
                                                                              'organisation_input_label') ??
                                                                      '',
                                                                  labelStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                  ), //label style
                                                                  prefixIcon:
                                                                      const OrganisationIcon(),
                                                                  hintText: LocalizationService.of(
                                                                              context)
                                                                          ?.translate(
                                                                              'organisation_input_label') ??
                                                                      '',
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                autofocus: true,
                                                                validator:
                                                                    (String?
                                                                        value) {
                                                                  //print(value.length);
                                                                  return (value !=
                                                                              null &&
                                                                          value.length <
                                                                              2)
                                                                      ? LocalizationService.of(context)
                                                                              ?.translate('invalid_organisation_message') ??
                                                                          ''
                                                                      : null;
                                                                },
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() =>
                                                                      organisation =
                                                                          val);
                                                                }),
                                                            const SizedBox(
                                                                height: 15.0),
                                                          ],
                                                        )
                                                      : Container(),
                                                  SizedBox(
                                                    width: ResponsiveValue(
                                                        context,
                                                        defaultValue: 300.0,
                                                        valueWhen: const [
                                                          Condition.largerThan(
                                                              name: MOBILE,
                                                              value: 300.0),
                                                          Condition.smallerThan(
                                                              name: TABLET,
                                                              value: double
                                                                  .infinity)
                                                        ]).value,
                                                    child: TextFormField(
                                                        decoration:
                                                            InputDecoration(
                                                                hintText: LocalizationService.of(
                                                                            context)
                                                                        ?.translate(
                                                                            'email_input_hinttext') ??
                                                                    '',
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    width: 2.0,
                                                                  ),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Theme.of(
                                                                            context)
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
                                                                labelStyle:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                ), //label style
                                                                prefixIcon:
                                                                    const EmailIcon()),
                                                        textAlign:
                                                            TextAlign.left,
                                                        initialValue: email,
                                                        autofocus: true,
                                                        validator:
                                                            (String? value) {
                                                          return !EmailValidator
                                                                  .validate(
                                                                      value!)
                                                              ? 'Please provide a valid email.'
                                                              : null;
                                                        },
                                                        onChanged: (val) {
                                                          setState(() =>
                                                              email = val);
                                                        }),
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  SizedBox(
                                                      width: ResponsiveValue(
                                                          context,
                                                          defaultValue: 300.0,
                                                          valueWhen: const [
                                                            Condition
                                                                .largerThan(
                                                                    name:
                                                                        MOBILE,
                                                                    value:
                                                                        300.0),
                                                            Condition.smallerThan(
                                                                name: TABLET,
                                                                value: double
                                                                    .infinity)
                                                          ]).value,
                                                      child:
                                                  TextFormField(
                                                      obscureText: obscureText,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: LocalizationService
                                                                    .of(context)
                                                                ?.translate(
                                                                    'password_input_hinttext') ??
                                                            '',
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        border: const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                        labelText: LocalizationService
                                                                    .of(context)
                                                                ?.translate(
                                                                    'password_input_label') ??
                                                            '',
                                                        labelStyle:
                                                            const TextStyle(
                                                          fontSize: 15,
                                                        ), //label style
                                                        prefixIcon:
                                                            const PasswordIcon(),
                                                        suffixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 0, 15, 0),
                                                          child: IconButton(
                                                              onPressed: () =>
                                                                  toggleObscure(),
                                                              icon: Icon(
                                                                obscureText ==
                                                                        true
                                                                    ? (defaultTargetPlatform == TargetPlatform.iOS ||
                                                                            defaultTargetPlatform ==
                                                                                TargetPlatform
                                                                                    .macOS)
                                                                        ? CupertinoIcons
                                                                            .eye
                                                                        : FontAwesomeIcons
                                                                            .eye
                                                                    : (defaultTargetPlatform == TargetPlatform.iOS ||
                                                                            defaultTargetPlatform ==
                                                                                TargetPlatform
                                                                                    .macOS)
                                                                        ? CupertinoIcons
                                                                            .eye_slash
                                                                        : FontAwesomeIcons
                                                                            .eyeSlash,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                size: 20.0,
                                                              )),
                                                        ),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                      autofocus: true,
                                                      validator:
                                                          (String? value) {
                                                        return (value != null &&
                                                                value.length <
                                                                    2)
                                                            ? LocalizationService.of(
                                                                        context)
                                                                    ?.translate(
                                                                        'invalid_password_message') ??
                                                                ''
                                                            : null;
                                                      },
                                                      onChanged: (val) {
                                                        setState(() =>
                                                            password = val);
                                                      })),
                                                  const SizedBox(height: 15.0),
                                                  SizedBox(
                                                    width: ResponsiveValue(
                                                        context,
                                                        defaultValue: 300.0,
                                                        valueWhen: const [
                                                          Condition.largerThan(
                                                              name: MOBILE,
                                                              value: 300.0),
                                                          Condition.smallerThan(
                                                              name: TABLET,
                                                              value: double
                                                                  .infinity)
                                                        ]).value,
                                                    child: signup == false
                                                        ? (defaultTargetPlatform ==
                                                                    TargetPlatform
                                                                        .iOS ||
                                                                defaultTargetPlatform ==
                                                                    TargetPlatform
                                                                        .macOS)
                                                            ? CupertinoButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    setState(() =>
                                                                        loader =
                                                                            true);
                                                                    bool
                                                                        success =
                                                                        await AgentService().signInUsingEmailAndPassword(
                                                                            email,
                                                                            password);
                                                                    if (success ==
                                                                        false) {
                                                                      setState(
                                                                          () =>
                                                                              {
                                                                                loader = false
                                                                              });
                                                                      if (!mounted) {
                                                                        return;
                                                                      }

                                                                      // SnackBarService().errorSnackBar(
                                                                      //     'authentication_error_snackbar_label',
                                                                      //     context);
                                                                    }
                                                                  } else {
                                                                    setState(
                                                                        () => {
                                                                              loader = false,
                                                                            });
                                                                  }
                                                                },
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    loader ==
                                                                            true
                                                                        ? LocalizationService.of(context)?.translate('loader_button_label') ??
                                                                            ''
                                                                        : LocalizationService.of(context)?.translate('sign_in_button_label') ??
                                                                            '',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              )
                                                            : ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    setState(() =>
                                                                        loader =
                                                                            true);
                                                                    bool
                                                                        success =
                                                                        await AgentService().signInUsingEmailAndPassword(
                                                                            email,
                                                                            password);
                                                                    if (success ==
                                                                        false) {
                                                                      if (!mounted) {
                                                                        return;
                                                                      }
                                                                      setState(
                                                                          () =>
                                                                              {
                                                                                loader = false
                                                                              });
                                                                      // SnackBarService().errorSnackBar('authentication_error_snackbar_label', context);
                                                                    }
                                                                  } else {
                                                                    setState(
                                                                        () => {
                                                                              loader = false,
                                                                            });
                                                                  }
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                        shape: MaterialStateProperty
                                                                            .all(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                )),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          15.0),
                                                                  child: Text(
                                                                    loader ==
                                                                            true
                                                                        ? LocalizationService.of(context)?.translate('loader_button_label') ??
                                                                            ''
                                                                        : LocalizationService.of(context)?.translate('sign_in_button_label') ??
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
                                                        : (defaultTargetPlatform ==
                                                                    TargetPlatform
                                                                        .iOS ||
                                                                defaultTargetPlatform ==
                                                                    TargetPlatform
                                                                        .macOS)
                                                            ? CupertinoButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    setState(() =>
                                                                        loader =
                                                                            true);
                                                                    bool success = await AgentService().signUpUsingEmailAndPassword(
                                                                        email:
                                                                            email,
                                                                        password:
                                                                            password);
                                                                    if (success ==
                                                                        true) {
                                                                      if (!mounted) {
                                                                        return;
                                                                      }
                                                                      setState(() =>
                                                                          loader =
                                                                              false);
                                                                      // SnackBarService().successSnackBar('sign_up_snackbar_label', context);
                                                                    }
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      loader =
                                                                          false;
                                                                    });
                                                                  }
                                                                },
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    loader ==
                                                                            true
                                                                        ? LocalizationService.of(context)?.translate('loader_button_label') ??
                                                                            ''
                                                                        : LocalizationService.of(context)?.translate('sign_up_button_label') ??
                                                                            '',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              )
                                                            : ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    setState(() =>
                                                                        loader =
                                                                            true);
                                                                    bool success = await AgentService().signUpUsingEmailAndPassword(
                                                                        organisation:
                                                                            organisation,
                                                                        email:
                                                                            email,
                                                                        password:
                                                                            password);
                                                                    if (success ==
                                                                        true) {
                                                                      if (!mounted) {
                                                                        return;
                                                                      }
                                                                      setState(() =>
                                                                          loader =
                                                                              false);
                                                                      // SnackBarService().successSnackBar('sign_up_snackbar_label', context);
                                                                    }
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      loader =
                                                                          false;
                                                                    });
                                                                  }
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                        shape: MaterialStateProperty
                                                                            .all(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                )),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          15.0),
                                                                  child: Text(
                                                                    loader ==
                                                                            true
                                                                        ? LocalizationService.of(context)?.translate('loader_button_label') ??
                                                                            ''
                                                                        : LocalizationService.of(context)?.translate('sign_up_button_label') ??
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
                                                  const SizedBox(height: 20.0),
                                                  GestureDetector(
                                                      child: Text(
                                                          LocalizationService.of(
                                                                      context)
                                                                  ?.translate(
                                                                      'reset_password_link_label') ??
                                                              '',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      onTap: () {
                                                        toggleReset();
                                                      }),
                                                  const SizedBox(height: 30.0),
                                                  Row(children: <Widget>[
                                                    const Expanded(
                                                        child: Divider()),
                                                    Text(
                                                        LocalizationService.of(
                                                                    context)
                                                                ?.translate(
                                                                    'or') ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: ResponsiveValue(
                                                              context,
                                                              defaultValue:
                                                                  15.0,
                                                              valueWhen: const [
                                                                Condition.smallerThan(
                                                                    name:
                                                                        DESKTOP,
                                                                    value:
                                                                        15.0),
                                                              ]).value,
                                                        )),
                                                    const Expanded(
                                                        child: Divider()),
                                                  ]),
                                                  const SizedBox(height: 30.0),
                                                  SizedBox(
                                                    width: ResponsiveValue(
                                                        context,
                                                        defaultValue: 300.0,
                                                        valueWhen: const [
                                                          Condition.largerThan(
                                                              name: MOBILE,
                                                              value: 300.0),
                                                          Condition.smallerThan(
                                                              name: TABLET,
                                                              value: double
                                                                  .infinity)
                                                        ]).value,
                                                    child: (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoButton(
                                                            onPressed: () {
                                                              toggleSignUp();
                                                            },
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                signup == false
                                                                    ? LocalizationService.of(context)?.translate(
                                                                            'sign_up_switcher_link_label') ??
                                                                        ''
                                                                    : LocalizationService.of(context)
                                                                            ?.translate('sign_in_switcher_link_label') ??
                                                                        '',
                                                                style: TextStyle(
                                                                    fontSize: ResponsiveValue(context, defaultValue: 15.0, valueWhen: const [
                                                                      Condition.smallerThan(
                                                                          name:
                                                                              DESKTOP,
                                                                          value:
                                                                              15.0),
                                                                    ]).value,
                                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          )
                                                        : ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                            onPressed: () {
                                                              toggleSignUp();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                signup == false
                                                                    ? LocalizationService.of(context)?.translate(
                                                                            'sign_up_switcher_link_label') ??
                                                                        ''
                                                                    : LocalizationService.of(context)
                                                                            ?.translate('sign_in_switcher_link_label') ??
                                                                        '',
                                                                style: TextStyle(
                                                                    fontSize: ResponsiveValue(context, defaultValue: 15.0, valueWhen: const [
                                                                      Condition.smallerThan(
                                                                          name:
                                                                              DESKTOP,
                                                                          value:
                                                                              15.0),
                                                                    ]).value,
                                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ))
                                          : Form(
                                              key: formKey,
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                      LocalizationService.of(
                                                                  context)
                                                              ?.translate(
                                                                  'reset_password_header_label') ??
                                                          '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(height: 40.0),
                                                  TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: LocalizationService
                                                                          .of(
                                                                              context)
                                                                      ?.translate(
                                                                          'email_input_hinttext') ??
                                                                  '',
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
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
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                              ), //label style
                                                              prefixIcon:
                                                                  const EmailIcon()),
                                                      textAlign: TextAlign.left,
                                                      initialValue: email,
                                                      autofocus: true,
                                                      validator:
                                                          (String? value) {
                                                        return !EmailValidator
                                                                .validate(
                                                                    value!)
                                                            ? 'Please provide a valid email.'
                                                            : null;
                                                      },
                                                      onChanged: (val) {
                                                        setState(
                                                            () => email = val);
                                                      }),
                                                  const SizedBox(height: 15.0),
                                                  SizedBox(
                                                    width: ResponsiveValue(
                                                        context,
                                                        defaultValue: 300.0,
                                                        valueWhen: const [
                                                          Condition.largerThan(
                                                              name: MOBILE,
                                                              value: 300.0),
                                                          Condition.smallerThan(
                                                              name: TABLET,
                                                              value: double
                                                                  .infinity)
                                                        ]).value,
                                                    child: (defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS ||
                                                            defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .macOS)
                                                        ? CupertinoButton(
                                                            onPressed:
                                                                () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() =>
                                                                    loader =
                                                                        true);
                                                                await AgentService()
                                                                    .resetPassword(
                                                                        email);
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                // SnackBarService()
                                                                //     .successSnackBar(
                                                                //         'reset_password_snackbar_label',
                                                                //         context);
                                                              } else {
                                                                setState(() {
                                                                  loader =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                loader == true
                                                                    ? LocalizationService.of(context)?.translate(
                                                                            'loader_button_label') ??
                                                                        ''
                                                                    : LocalizationService.of(context)
                                                                            ?.translate('reset_password_button_label') ??
                                                                        '',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                        : ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() =>
                                                                    loader =
                                                                        true);
                                                                await AgentService()
                                                                    .resetPassword(
                                                                        email);
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                // SnackBarService().successSnackBar(
                                                                //     'reset_password_snackbar_label', context);
                                                              } else {
                                                                setState(() {
                                                                  loader =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Text(
                                                                loader == true
                                                                    ? LocalizationService.of(context)?.translate(
                                                                            'loader_button_label') ??
                                                                        ''
                                                                    : LocalizationService.of(context)
                                                                            ?.translate('reset_password_button_label') ??
                                                                        '',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                  const SizedBox(height: 30.0),
                                                  GestureDetector(
                                                      child: Text(
                                                          LocalizationService.of(
                                                                      context)
                                                                  ?.translate(
                                                                      'go_back_home_link_label') ??
                                                              '',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      onTap: () {
                                                        toggleReset();
                                                      })
                                                ],
                                              )),
                                    ))),
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: drawer(),
    );
  }
}
