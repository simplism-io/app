import 'package:flutter/material.dart';

import '../buttons/reply_message_button_widget.dart';
import '../form_fields/reply_form_field_widget.dart';

class ReplyMessageFormWidget extends StatefulWidget {
  final Map message;
  const ReplyMessageFormWidget({super.key, required this.message});

  @override
  State<ReplyMessageFormWidget> createState() => _ReplyMessageFormWidgetState();
}

class _ReplyMessageFormWidgetState extends State<ReplyMessageFormWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 0,
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: const [
                      ReplyMessageFormFieldWidget(),
                    ],
                  ),
                ],
              )),
        ),
        Row(
          children: [
            const Spacer(),
            ReplyMessageButtonWidget(formKey: formKey, message: widget.message),
          ],
        ),
      ],
    );
  }
}
