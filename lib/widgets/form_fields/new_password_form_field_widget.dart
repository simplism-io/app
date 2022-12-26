import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../icons/password_eye_slash_icon_widget.dart';
import '../icons/password_key_hole_icon_widget.dart';

class NewPasswordFormFieldWidget extends StatefulWidget {
  const NewPasswordFormFieldWidget({super.key});

  @override
  State<NewPasswordFormFieldWidget> createState() =>
      _NewPasswordFormFieldWidgetState();
}

class _NewPasswordFormFieldWidgetState
    extends State<NewPasswordFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ResponsiveValue(context, defaultValue: 400.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 400.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: Consumer<FormService>(
            builder: (context, form, child) => TextFormField(
                obscureText: form.obscureText,
                decoration: InputDecoration(
                  hintText: LocalizationService.of(context)
                          ?.translate('new_password_input_hinttext') ??
                      '',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.0,
                    ),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: LocalizationService.of(context)
                          ?.translate('new_password_input_label') ??
                      '',
                  labelStyle: const TextStyle(
                    fontSize: 15,
                  ), //label style
                  prefixIcon: const PasswordKeyHoleIconWidget(),
                  suffixIcon: const PasswordEyeSlashIconWidget(),
                ),
                textAlign: TextAlign.left,
                autofocus: true,
                validator: (String? value) {
                  return (value != null && value.length < 2)
                      ? LocalizationService.of(context)
                              ?.translate('invalid_password_message') ??
                          ''
                      : null;
                },
                onChanged: (val) {
                  setState(() => FormService.newPassword = val);
                })));
  }
}
