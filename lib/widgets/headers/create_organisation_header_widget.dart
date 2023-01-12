import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class CreateOrganisationHeaderWidget extends StatelessWidget {
  const CreateOrganisationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)
                ?.translate('create_organisation_header_label') ??
            '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
