import 'package:flutter/material.dart';

import '../../services/form_service.dart';
import '../buttons/create_organisation_button_widget.dart';
import '../form_fields/organisation_form_field_widget.dart';
import '../headers/create_organisation_header_widget.dart';

class CreateOrganisationFormWidget extends StatefulWidget {
  const CreateOrganisationFormWidget({super.key});

  @override
  State<CreateOrganisationFormWidget> createState() =>
      _CreateOrganisationFormWidgetState();
}

class _CreateOrganisationFormWidgetState
    extends State<CreateOrganisationFormWidget> {
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
                const CreateOrganisationHeaderWidget(),
                const SizedBox(height: 40.0),
                const OrganisationFormFieldWidget(),
                const SizedBox(height: 15.0),
                CreateOrganisationButtonWidget(formKey: formKey),
              ],
            )),
      ),
    );
  }
}
