import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class ReplyMessageFormFieldWidget extends StatefulWidget {
  final String? name;
  const ReplyMessageFormFieldWidget({super.key, this.name});

  @override
  State<ReplyMessageFormFieldWidget> createState() =>
      _ReplyMessageFormFieldWidgetState();
}

class _ReplyMessageFormFieldWidgetState
    extends State<ReplyMessageFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 960.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 960.0),
        Condition.smallerThan(name: TABLET, value: 300.0)
      ]).value,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 0.0),
        child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: LocalizationService.of(context)
                      ?.translate('name_input_label') ??
                  '',
            ),
            textCapitalization: TextCapitalization.words,
            textAlign: TextAlign.left,
            autofocus: true,
            validator: (String? value) {
              //print(value.length);
              return (value != null && value.length < 2)
                  ? LocalizationService.of(context)
                          ?.translate('invalid_name_message') ??
                      ''
                  : null;
            },
            onChanged: (val) {
              setState(
                  () => {FormService.subject = '', FormService.body = val});
            }),
      ),
    );
  }
}
