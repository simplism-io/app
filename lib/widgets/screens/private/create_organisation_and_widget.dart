import 'package:flutter/material.dart';

import '../../forms/create_organisation_form.dart';

class CreateOrganisationScreenWidget extends StatelessWidget {
  const CreateOrganisationScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Center(
            child: Column(
          children: const [
            CreateOrganisationAndAgentFormWidget(),
          ],
        )));
  }
}
