import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/form_service.dart';
import '../buttons/sign_in_up_button_widget.dart';
import '../buttons/sign_in_with_apple_button_widget.dart';
import '../buttons/sign_in_with_google_button_widget.dart';
import '../form_fields/email_form_field_widget.dart';
import '../form_fields/organisation_form_field_widget.dart';
import '../form_fields/password_form_field_widget.dart';
import '../headers/sign_in_up_header_widget.dart';
import '../links/reset_password_link_widget.dart';
import '../sections/or_section_widget.dart';
import '../buttons/sign_in_up_switcher_button_widget.dart';

class SignInUpFormsWidget extends StatelessWidget {
  SignInUpFormsWidget({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const SignInUpHeaderWidget(),
            const SizedBox(height: 40.0),
            (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.macOS)
                ? const SignInWithAppleButtonWidget()
                : Container(),
            (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.macOS)
                ? const SizedBox(height: 15.0)
                : Container(),
            const SignInWithGoogleButtonWidget(),
            const SizedBox(height: 30.0),
            const OrSectionWidget(),
            const SizedBox(height: 30.0),
            Consumer<FormService>(
                builder: (context, form, child) => form.signup == true
                    ? Column(
                        children: const [
                          OrganisationFormFieldWidget(),
                          SizedBox(height: 15.0),
                        ],
                      )
                    : Container()),
            const EmailFormFieldWidget(email: ''),
            const SizedBox(height: 15.0),
            const PasswordFormFieldWidget(),
            const SizedBox(height: 15.0),
            SignInUpButtonWidget(formKey: formKey),
            const SizedBox(height: 20.0),
            const ResetPasswordLinkWidget(),
            const SizedBox(height: 30.0),
            const OrSectionWidget(),
            const SizedBox(height: 30.0),
            const SignInUpSwitcherButtonWidget(),
          ],
        ));
  }
}
