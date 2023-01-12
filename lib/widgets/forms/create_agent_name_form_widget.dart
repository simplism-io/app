import 'package:flutter/material.dart';

import '../buttons/create_agent_name_button_widget.dart';
import '../form_fields/name_form_field_widget.dart';
import '../headers/create_agent_name_header_widget.dart';

class CreateAgentNameFormWidget extends StatefulWidget {
  const CreateAgentNameFormWidget({super.key});

  @override
  State<CreateAgentNameFormWidget> createState() =>
      _CreateAgentNameFormWidgetState();
}

class _CreateAgentNameFormWidgetState extends State<CreateAgentNameFormWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const CreateAgentNameHeaderWidget(),
                const SizedBox(height: 40.0),
                const NameFormFieldWidget(),
                const SizedBox(height: 15.0),
                CreateAgentNameButtonWidget(formKey: formKey),
              ],
            )),
      ),
    );
  }
}
