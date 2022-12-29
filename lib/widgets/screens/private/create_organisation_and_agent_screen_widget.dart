import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../forms/create_organisation_and_agent_form.dart';

class CreateOrganisationAndAgentScreenWidget extends StatelessWidget {
  const CreateOrganisationAndAgentScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CreateOrganisationAndAgentFormWidget());
  }
}
