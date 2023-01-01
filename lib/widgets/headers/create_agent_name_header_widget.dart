import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class CreateAgentNameHeaderWidget extends StatelessWidget {
  const CreateAgentNameHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)
                ?.translate('create_agent_name_header') ??
            '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
