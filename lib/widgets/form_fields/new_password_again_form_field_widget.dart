import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../icons/password_show_hide_widget.dart';
import '../icons/password_icon_widget.dart';

class NewPasswordAgainFormFieldWidget extends StatefulWidget {
  const NewPasswordAgainFormFieldWidget({super.key});

  @override
  State<NewPasswordAgainFormFieldWidget> createState() =>
      _NewPasswordAgainFormFieldWidgetState();
}

class _NewPasswordAgainFormFieldWidgetState
    extends State<NewPasswordAgainFormFieldWidget> {
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
                        ?.translate('new_password_again_input_hinttext') ??
                    '',
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                        ?.translate('new_password_again_input_label') ??
                    '',
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.secondary,
                ), //label style
                prefixIcon: const PasswordIconWidget(),
                suffixIcon: const PasswordShowHideIconWidget(),
              ),
              textAlign: TextAlign.left,
              autofocus: false,
              validator: (String? value) {
                return (value != FormService.newPassword)
                    ? LocalizationService.of(context)
                            ?.translate('invalid_password_again_message') ??
                        ''
                    : null;
              },
              onChanged: (val) {
                setState(() => FormService.newPasswordAgain = val);
              }),
        ));
  }
}
