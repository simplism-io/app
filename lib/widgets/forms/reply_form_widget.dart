import 'package:flutter/material.dart';

import '../buttons/create_organisation_button_widget.dart';
import '../form_fields/reply_form_field_widget.dart';

class ReplyMessageFormWidget extends StatefulWidget {
  const ReplyMessageFormWidget({super.key});

  @override
  State<ReplyMessageFormWidget> createState() =>
      _CreateOrganisationFormWidgetState();
}

class _CreateOrganisationFormWidgetState extends State<ReplyMessageFormWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Theme.of(context).colorScheme.onSurface,
      child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const ReplyMessageFormFieldWidget(),
              const SizedBox(height: 15.0),
              CreateOrganisationButtonWidget(formKey: formKey),
            ],
          )),
    );
  }
}
