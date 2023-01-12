import 'package:flutter/material.dart';

import '../buttons/reply_message_button_widget.dart';
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
      child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Row(
                children: const [
                  //ReplyMessageFormFieldWidget(),
                ],
              ),
              Expanded(
                child: Row(
                  children: const [
                    Spacer(),
                    //ReplyMessageButtonWidget(formKey: formKey),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
            ],
          )),
    );
  }
}
