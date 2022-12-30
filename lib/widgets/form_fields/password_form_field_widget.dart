import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../icons/password_show_hide_widget.dart';
import '../icons/password_icon_widget.dart';

class PasswordFormFieldWidget extends StatefulWidget {
  const PasswordFormFieldWidget({super.key});

  @override
  State<PasswordFormFieldWidget> createState() =>
      _PasswordFormFieldWidgetState();
}

class _PasswordFormFieldWidgetState extends State<PasswordFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 300.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: Consumer<FormService>(
          builder: (context, form, child) => TextFormField(
              obscureText: form.obscureText,
              decoration: InputDecoration(
                hintText: LocalizationService.of(context)
                        ?.translate('password_input_hinttext') ??
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
                labelText: LocalizationService.of(context)
                        ?.translate('password_input_label') ??
                    '',
                labelStyle: const TextStyle(
                  fontSize: 15,
                ), //label style
                prefixIcon: const PasswordIconWidget(),
                suffixIcon: const PasswordShowHideIconWidget(),
              ),
              textAlign: TextAlign.left,
              autofocus: true,
              validator: (String? value) {
                return (value != null && value.length < 2)
                    ? 'Please provide a valid password.'
                    : null;
              },
              onChanged: (val) {
                setState(() => FormService.password = val);
              }),
        ));
  }
}
